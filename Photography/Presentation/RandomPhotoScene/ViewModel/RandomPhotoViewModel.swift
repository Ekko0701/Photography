//
//  RandomPhotoViewModel.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation

import RxSwift
import RxRelay

final class RandomPhotoViewModel {
    private let randomPhotosUseCase: RandomPhotosUseCase
    var photos: [Photo] = []
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let cardDidSwipeLeft: PublishRelay<Void>
        let cardDidSwipeRight: PublishRelay<Void>
        let bookmarkButtonTapped: PublishRelay<Void>
        let removeButtonTapped: PublishRelay<Void>
        let infoButtonTapped: PublishRelay<Void>
    }
    
    struct Output {
        var didLoadData = PublishRelay<Bool>()
        var cardWillSwipeLeft = PublishRelay<Void>()
        var cardWillSwipeRight = PublishRelay<Void>()
    }
    
    init(
        randomPhotosUseCase: RandomPhotosUseCase
    ) {
        self.randomPhotosUseCase = randomPhotosUseCase
    }
    
    func transform(
        from input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .flatMap { [unowned self] _ in
                return self.fetchRandomPhotos(
                    requestValue: RandomPhotosUseCaseRequestValue(
                        count: 3))
            }.subscribe(onNext: {[weak self] photos in
                self?.photos = photos
                output.didLoadData.accept(true)
            }).disposed(by: disposeBag)
        
        input.cardDidSwipeLeft
            .flatMap { [weak self] _ in
                return self?.fetchRandomPhotos(requestValue: RandomPhotosUseCaseRequestValue(count: 1)) ?? Observable.just([])
            }.subscribe(onNext: {[weak self] photo in
                self?.photos.append(contentsOf: photo)
                self?.photos.removeFirst()
                output.didLoadData.accept(true)
            }).disposed(by: disposeBag)
        
        input.cardDidSwipeRight
            .flatMap { [weak self] _ in
                return self?.fetchRandomPhotos(requestValue: RandomPhotosUseCaseRequestValue(count: 1)) ?? Observable.just([])
            }.subscribe(onNext: {[weak self] photo in
                self?.photos.append(contentsOf: photo)
                
                // 북마크 생성
                let bookmarkPhoto = self?.photos.first
                self?.createBookmark(photo: bookmarkPhoto!)
                
                self?.photos.removeFirst()
                output.didLoadData.accept(true)
            }).disposed(by: disposeBag)
        
        input.bookmarkButtonTapped
            .bind(to: output.cardWillSwipeRight)
            .disposed(by: disposeBag)
        
        input.removeButtonTapped
            .bind(to: output.cardWillSwipeLeft)
            .disposed(by: disposeBag)
        
        input.infoButtonTapped
            .subscribe(onNext: { _ in
                print("정보 버튼 클릭")
            }).disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Transform private methods
extension RandomPhotoViewModel {
    private func fetchRandomPhotos(
        requestValue: RandomPhotosUseCaseRequestValue
    ) -> Observable<[Photo]> {
        print("에코: 랜덤 사진 불러오기")
        return randomPhotosUseCase.fetchRandomPhotos(
            requestValue: requestValue
        )
    }
    
    private func createBookmark(photo: Photo) {
        randomPhotosUseCase.createBookmark(photo: photo)
    }
}
