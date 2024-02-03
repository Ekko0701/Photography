//
//  RealmRepository.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RxSwift

protocol RealmRepository {
    func fetchPhotos() -> Observable<[Photo]>
    func createBookmark(photo: Photo)
    func deleteBookmark(photo: Photo)
}
