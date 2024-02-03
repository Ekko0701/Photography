//
//  PhotoListRepository.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift

protocol PhotoListRepository {
    // 사진 목록 요청
    func fetchPhotoLists(
        page: Int,
        perPage: Int
    ) -> Observable<[Photo]>
    
//    func fetchPhotoDetail(
//        id: String
//    ) -> Observable<Photo>
}
