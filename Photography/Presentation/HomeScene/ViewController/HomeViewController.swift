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
    private var models = [Photo]()
    
    private var fetchMorePhoto: PublishSubject<Void> = PublishSubject<Void>()
    
    // MARK: - UI elements
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2 // 2행 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = .black
        indicator.stopAnimating()
        return indicator
    }()
    
    // MARK: - Initilizer
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCollectionView()
        self.setUI()
        self.bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Private methods
    private func setUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}

// MARK: - Binding
extension HomeViewController {
    func bindViewModel() {
        guard let viewModel = homeViewModel else { return }
        
        // INPUT
        let input = HomeViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            fetchMorePhoto: self.fetchMorePhoto
        )
        
        // OUTPUT
        let output = viewModel.transform(
            from: input,
            disposeBag: self.disposeBag
        )
        
        output.didLoadPhotoList
            .subscribe(onNext: { [weak self] photoList in
                self?.models.append(contentsOf: photoList)
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.nowFetching
            .subscribe(onNext: { [weak self] isFetching in
                if isFetching {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - CollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Models count: \(models.count)")
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(imageURL: models[indexPath.row].imageURL)
        return cell
    }
}

// MARK: - CollectionView Delegate WaterfallLayout
extension HomeViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let imageWidth: CGFloat = self.models[indexPath.row].width
        let imageHeight: CGFloat = self.models[indexPath.row].height
        
        let imageViewWidth: CGFloat = view.frame.size.width / 2
        
        let ratio = imageWidth / imageHeight
        let imageViewHeight: CGFloat = imageViewWidth / ratio
        
        return CGSize(width: view.frame.size.width / 2,
                      height: imageViewHeight)
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
