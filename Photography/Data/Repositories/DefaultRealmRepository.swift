//
//  DefaultRealmRepository.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RxSwift
import RealmSwift

final class DefaultRealmRepository{
    private let realmService: RealmService
    
    init(realmService: RealmService) {
        self.realmService = realmService
    }
}

extension DefaultRealmRepository: RealmRepository {
    func fetchPhotos() -> Observable<[Photo]> {
        realmService.readAll()
            .flatMap { data in
                if let photoObjects = data as? [PhotoObject] {
                    return Observable.just(photoObjects.map { $0.toDomain() })
                } else {
                    return Observable.just([])
                }
            }.asObservable()
    }
    
    func createBookmark(photo: Photo) {
        realmService.create(object: toObject(photo: photo))
    }
    
    func deleteBookmark(photo: Photo) {
        realmService.delete(object: toObject(photo: photo))
    }
    
    // TODO: - 재구성 필요
    private func toObject(photo: Photo) -> PhotoObject {
        let photoObject = PhotoObject()
        photoObject.id = photo.imageName
        photoObject.imageURL = photo.imageURL
        return photoObject
    }
}
