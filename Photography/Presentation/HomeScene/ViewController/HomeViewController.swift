//
//  ViewController.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import CHTCollectionViewWaterfallLayout

class HomeViewController: UIViewController {

    // MARK: - Properties
    var homeViewModel: HomeViewModel?
    private let disposeBag = DisposeBag()
    private var photos = [Photo]()
    private var bookmarkData: [Photo] = []
    
    var isLoading: Bool = false
    
    private var fetchMorePhoto: PublishSubject<Void> = PublishSubject<Void>()
    private var photoDidTap: PublishSubject<Photo> = PublishSubject<Photo>()
    
    // MARK: - UI elements
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2 // 2행 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        // Register Cells
        collectionView.register(BookMarkCell.self, forCellWithReuseIdentifier: BookMarkCell.identifier)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        // Register ReusableView
        collectionView.register(LoadingIndicatorReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingIndicatorReusableView.identifier)
        collectionView.register(PhotoCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoCollectionViewHeader.identifier)
        
        return collectionView
    }()
    
    // MARK: - Initilizer
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = viewModel
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigation()
        self.setCollectionView()
        self.setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Private methods
    /// Set Navigation Bar
    private func setNavigation() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = false
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        navigationController.navigationBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
        
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34) // 필요에 따라 조정
        navigationItem.titleView = titleImageView
        
        // 구분선 추가
        let dividerView = UIView()
        dividerView.backgroundColor = .gray30
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        navigationController.navigationBar.addSubview(dividerView)
        
        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(navigationController.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)}
    }
    
    private func setUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            
        }
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func updateFooterVisibility() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: - Binding
extension HomeViewController {
    func bindViewModel() {
        guard let viewModel = homeViewModel else { return }
        
        // INPUT
        let input = HomeViewModel.Input(
            viewDidLoad: self.rx.methodInvoked(#selector(UIViewController.viewDidLoad)).map { _ in },
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            fetchMorePhoto: self.fetchMorePhoto,
            photoSelected: self.photoDidTap
        )
        
        // OUTPUT
        let output = viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        )
        
        output.didLoadPhotoList
            .subscribe(onNext: { [weak self] photoList in
                self?.photos.append(contentsOf: photoList)
                self?.collectionView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        output.didLoadBookmarkPhotoList
            .subscribe(onNext: { [weak self] photoList in
                print("북마크 결과: \(photoList)")
                self?.bookmarkData = photoList
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.nowFetching
            .subscribe(onNext: { [weak self] isFetching in
                self?.isLoading = isFetching
                self?.updateFooterVisibility()
            })
            .disposed(by: disposeBag)
        
        output.presentDetailView
            .subscribe(onNext: { [weak self] photoID in
                self?.presentDetailViewController(with: photoID)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Flow methos
extension HomeViewController {
    private func presentDetailViewController(with photoID: String) {
        let photoDetailViewModel = PhotoDetailViewModel(photoID: photoID, photoDetailUseCase: DefaultPhotoDetailUseCase(
            photoRepository: DefaultPhotoListRepository(alamofireService: DefaultAlamofireNetworkService()),
            realmRepository: DefaultRealmRepository(realmService: DefaultRealmService()))
        )
        
        let detailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
        detailViewController.modalPresentationStyle = .overFullScreen
        self.present(detailViewController, animated: true)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return bookmarkData.isEmpty ? 0 : 1
        } else {
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BookMarkCell.identifier,
                for: indexPath
            ) as? BookMarkCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(
                bookmarks: bookmarkData,
                buttonTapSubject: self.photoDidTap
            )
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCollectionViewCell.identifier,
                for: indexPath
            ) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: photos[indexPath.row])
            return cell
        }
    }
    
    // Configure Header & Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingIndicatorReusableView.identifier, for: indexPath) as! LoadingIndicatorReusableView
            return footer
        } else {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PhotoCollectionViewHeader.identifier,
                for: indexPath
            ) as? PhotoCollectionViewHeader else {
                return UICollectionReusableView()
            }
            
            if indexPath.section == 0 {
                header.configure(title: "북마크")
            } else {
                header.configure(title: "최신 이미지")
            }
            
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.photoDidTap.onNext(photos[indexPath.row])
    }
}

// MARK: - CollectionView Delegate WaterfallLayout
extension HomeViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.size.width, height: 128)
        } else {
            let imageWidth: CGFloat = self.photos[indexPath.row].width
            let imageHeight: CGFloat = self.photos[indexPath.row].height
            
            let imageViewWidth: CGFloat = view.frame.size.width / 2
            
            let ratio = imageWidth / imageHeight
            let imageViewHeight: CGFloat = imageViewWidth / ratio
            
            return CGSize(width: view.frame.size.width / 2,
                          height: imageViewHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        
        if bookmarkData.isEmpty {
            if section == 0 {
                return 0
            } else {
                return 50
            }
        } else {
            return 50
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 150
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        if section == 1{
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets()
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            self.fetchMorePhoto.onNext(Void())
        }
    }
}
