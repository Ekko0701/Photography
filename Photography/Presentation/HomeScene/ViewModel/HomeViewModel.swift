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
    
    struct Input {
        let viewWillAppear: Observable<Void>
        // let photoSelected: Observable<String>
    }
    
    struct Output {
        var didLoadPhotoList = PublishRelay<[Photo]>()
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
        
        input.viewWillAppear
            .flatMap { [unowned self] _ in
                self.fetchPhotoList(
                    requestValue: PhotoListUseCaseRequestValue(
                        page: 1,
                        perPage: 10
                    )
                )
            }
            .bind(to: output.didLoadPhotoList)
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
