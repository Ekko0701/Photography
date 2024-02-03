//
//  DefaultRealmRepository.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RxSwift

final class DefaultRealmRepository{
    private let realmService: RealmService
    
    init(realmService: RealmService) {
        self.realmService = realmService
    }
}

extension DefaultRealmRepository: RealmRepository {
    func fetchPhotos() -> Observable<[Photo]> {
        return realmService.readAll()
    }
    
    func createBookmark(photo: Photo) {
        realmService.create(T: photo)
    }
    
    func deleteBookmark(photo: Photo) {
        realmService.delete(object: photo)
    }
}
