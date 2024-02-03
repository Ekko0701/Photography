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
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var randomPhotos: PublishSubject<[Photo]> = PublishSubject<[Photo]>()
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
                        count: 10)
                )
            }
            .bind(to: output.randomPhotos)
            .disposed(by: disposeBag)
        return output
    }
}

// MARK: - Transform private methods
extension RandomPhotoViewModel {
    private func fetchRandomPhotos(
        requestValue: RandomPhotosUseCaseRequestValue
    ) -> Observable<[Photo]> {
        return randomPhotosUseCase.fetchRandomPhotos(
            requestValue: requestValue
        )
    }
}
