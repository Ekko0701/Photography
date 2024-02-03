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
    private var cardModels: [Photo] = [
    ]
    
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
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }
        )
        
        // OUTPUT
        let output = viewModel.transform(
            from: input,
            disposeBag: disposeBag
        )
        
        output.randomPhotos
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] photos in
                guard let self = self else { return }
                print("결과는 \(photos)")
                cardModels.append(contentsOf: photos)
                cardStack.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension RandomPhotoViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        guard let viewModel = self.randomPhotoViewModel else { return SwipeCard() }
        card.content = PhotoCardView(with: cardModels[index])
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardModels.count
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        print("Swiped all cards!")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print("Swiped \(direction) on card \(index)")
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        print("Card tapped")
    }
}
