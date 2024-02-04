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
import Shuffle

class RandomPhotoViewController: UIViewController {
    // MARK: - Properties
    private var randomPhotoViewModel: RandomPhotoViewModel?
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var cardStack = SwipeCardStack()
    
    private let cardDidSwipeLeft: PublishRelay<Void> = PublishRelay<Void>()
    private let cardDidSwipeRight: PublishRelay<Void> = PublishRelay<Void>()
    private let bookmarkButtonDidTap: PublishRelay<Void> = PublishRelay<Void>()
    private let removeButtonDidTap: PublishRelay<Void> = PublishRelay<Void>()
    private let infoButtonDidTap: PublishRelay<String> = PublishRelay<String>()
    
    // MARK: - UI Components
    
    // MARK: - Initializers
    init(viewModel: RandomPhotoViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.randomPhotoViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = .black
        setUI()
        self.setNavigation()
        self.bindViewModel()
    }
    
    /// Set Navigation Bar
    private func setNavigation() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = false
        
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
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
        self.view.addSubview(self.cardStack)
        self.cardStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        self.cardStack.dataSource = self
        self.cardStack.delegate = self
    }
}

extension RandomPhotoViewController {
    func bindViewModel() {
        guard let viewModel = self.randomPhotoViewModel else { return }
        
        // INPUT
        let input = RandomPhotoViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            cardDidSwipeLeft: cardDidSwipeLeft,
            cardDidSwipeRight: cardDidSwipeRight,
            bookmarkButtonTapped: bookmarkButtonDidTap,
            removeButtonTapped: removeButtonDidTap,
            infoButtonTapped: infoButtonDidTap
        )
        
        // OUTPUT
        let output = viewModel.transform(
            from: input,
            disposeBag: disposeBag
        )
        
        output.didLoadData
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.cardStack.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.cardWillSwipeLeft
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.cardStack.swipe(.left, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.cardWillSwipeRight
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] _ in
                self?.cardStack.swipe(.right, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.presentDetailView
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] photoID in
                self?.presentDetailViewController(with: photoID)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Flow methos
extension RandomPhotoViewController {
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

extension RandomPhotoViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        guard let viewModel = self.randomPhotoViewModel else { return SwipeCard() }
        
        let photoCardView = PhotoCardView(with: viewModel.photos[index])
        
        photoCardView.cardViewBinding(
            bookmarkButtonTapped: self.bookmarkButtonDidTap,
            removeButtonTapped: self.removeButtonDidTap,
            infoButtonTapped: self.infoButtonDidTap,
            disposeBag: self.disposeBag
        )
        
        card.content = photoCardView
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return randomPhotoViewModel?.photos.count ?? 0
    }
    
//    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
//        print("Swiped all cards!")
//    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if direction == .left {
            self.cardDidSwipeLeft.accept(())
        } else {
            self.cardDidSwipeRight.accept(())
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
}
