//
//  HomeViewModel.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    private let photoListUseCase: PhotoListUseCase
    private var page: Int = 1
    private var isFetching = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let fetchMorePhoto: PublishSubject<Void>
    }
    
    struct Output {
        var didLoadPhotoList = PublishRelay<[Photo]>()
        var didLoadBookmarkPhotoList = PublishRelay<[Photo]>()
        var nowFetching: PublishSubject<Bool> = PublishSubject()
    }
    
    init(
        photoListUseCase: PhotoListUseCase
    ) {
        self.photoListUseCase = photoListUseCase
    }
    
    func transform(
        from input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        // View Will Appear, 처음 ViewLoad 될 때
//        input.viewDidLoad
//            .flatMapLatest { [unowned self] _ in
//                self.isFetching.accept(true)
//                return self.fetchPhotoList(
//                    requestValue: PhotoListUseCaseRequestValue(
//                        page: self.page,
//                        perPage: 10
//                    )
//                )
//                .do(onNext: { _ in self.isFetching.accept(false)})
//            }
//            .bind(to: output.didLoadPhotoList)
//            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .flatMap { [unowned self] _ in
                return self.fetchPhotoList(
                    requestValue: PhotoListUseCaseRequestValue(
                        page: self.page,
                        perPage: 10
                    )
                )
            }.bind(to: output.didLoadPhotoList)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .flatMap { [weak self] _ in
                return self?.photoListUseCase.fetchBookmarkPhotoList() ?? Observable.just([])
            }.bind(to: output.didLoadBookmarkPhotoList)
            .disposed(by: disposeBag)
        
        input.fetchMorePhoto
            .filter { [unowned self] _ in !self.isFetching.value }
            .flatMapLatest { [weak self] _ -> Observable<[Photo]> in
                guard let self = self else { return Observable.empty() }
                self.isFetching.accept(true)
                self.page += 1
                print("페이지: \(self.page)")
                return self.fetchPhotoList(
                    requestValue: PhotoListUseCaseRequestValue(
                        page: self.page,
                        perPage: 10
                    )
                )
                .do(onNext: { _ in self.isFetching.accept(false)})
            }
            .bind(to: output.didLoadPhotoList)
            .disposed(by: disposeBag)
        
        self.isFetching
            .bind(to: output.nowFetching)
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Transform private methods
extension HomeViewModel {
    private func fetchPhotoList(
        requestValue: PhotoListUseCaseRequestValue
    ) -> Observable<[Photo]> {
        return photoListUseCase.fetchPhotoList(
            requestValue: requestValue
        )
    }
}
