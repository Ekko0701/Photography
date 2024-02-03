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
        realmService.create(object: PhotoObject(from: photo))
    }
    
    func deleteBookmark(photo: Photo) {
        realmService.delete(object: PhotoObject(from: photo))
    }
    
    
}
