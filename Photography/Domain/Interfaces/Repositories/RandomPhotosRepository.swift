//
//  RandomPhotosRepository.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation

import RxSwift

protocol RandomPhotosRepository {
    // 랜덤 사진 요청
    func fetchRandomPhotos(
        count: Int
    ) -> Observable<[Photo]>
}
