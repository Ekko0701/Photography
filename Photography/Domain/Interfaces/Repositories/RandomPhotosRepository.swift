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
    
    // TODO: - 로컬 북마크 저장 필요
}
