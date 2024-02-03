//
//  PhotoDetailUseCase.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RxSwift

protocol PhotoDetailUseCase {
    func fetchPhotoDetail(from photoID: String) -> Observable<PhotoDetail>
}

final class DefaultPhotoDetailUseCase: PhotoDetailUseCase {
    private let photoRepository: PhotoListRepository
    private let realmRepository: RealmRepository
    
    init(
        photoRepository: PhotoListRepository,
        realmRepository: RealmRepository
    ) {
        self.photoRepository = photoRepository
        self.realmRepository = realmRepository
    }
    
    func fetchPhotoDetail(from photoID: String) -> Observable<PhotoDetail> {
        return self.photoRepository.fetchPhotoDetail(id: photoID)
    }
}
