//
//  PhotoListUseCase.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift

protocol PhotoListUseCase {
    func fetchPhotoList(
        requestValue: PhotoListUseCaseRequestValue
    ) -> Observable<[Photo]>
    
    func fetchBookmarkPhotoList() -> Observable<[Photo]>
}

final class DefaultPhotoListUseCase: PhotoListUseCase {
    private let photoRepository: PhotoListRepository
    private let realmRepository: RealmRepository
    
    init(
        photoRepository: PhotoListRepository,
        realmRepository: RealmRepository
    ) {
        self.photoRepository = photoRepository
        self.realmRepository = realmRepository
    }
    
    func fetchPhotoList(
        requestValue: PhotoListUseCaseRequestValue
    ) -> Observable<[Photo]> {
        return photoRepository.fetchPhotoLists(
            page: requestValue.page,
            perPage: requestValue.perPage
        )
    }
    
    func fetchBookmarkPhotoList() -> Observable<[Photo]> {
        return realmRepository.fetchPhotos()
    }
    
}

/// 사진 리스트 요청 시 필요한 값
struct PhotoListUseCaseRequestValue: Codable {
    // 키 값은 RequestDTO 생성 시 할당
    /// 페이지
    let page: Int
    /// 페이지당 아이템 수
    let perPage: Int // Default 10
}
