//
//  RandomPhotosUseCase.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation

import RxSwift

protocol RandomPhotosUseCase {
    func fetchRandomPhotos(
        requestValue: RandomPhotosUseCaseRequestValue
    ) -> Observable<[Photo]>
}

final class DefaultRandomPhotosUseCase: RandomPhotosUseCase {
    private let randomPhotosRepository: RandomPhotosRepository
    private let realmRepository: RealmRepository
    init(
        randomPhotosRepository: RandomPhotosRepository,
        realmRepository: RealmRepository
    ) {
        self.randomPhotosRepository = randomPhotosRepository
        self.realmRepository = realmRepository
    }
    
    func fetchRandomPhotos(
        requestValue: RandomPhotosUseCaseRequestValue
    ) -> Observable<[Photo]> {
        return randomPhotosRepository.fetchRandomPhotos(
            count: requestValue.count
        )
    }
}

/// 랜덤 사진 요청 api 파라미터
struct RandomPhotosUseCaseRequestValue: Codable {
    var count: Int = 5
}
