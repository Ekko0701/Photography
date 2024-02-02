//
//  DefaultPhotoListRepository.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift

final class DefaultPhotoListRepository {
    private let alamofireService: AlamofireNetworkService
    
    init(alamofireService: AlamofireNetworkService) {
        self.alamofireService = alamofireService
    }
}

extension DefaultPhotoListRepository: PhotoListRepository {
    func fetchPhotoLists(page: Int, perPage: Int) -> RxSwift.Observable<[Photo]> {
        let requestDTO = PhotoListRequestDTO(
            key: UnSplashAPIKey.publicKey,
            page: page,
            perPage: perPage
        )
        
        return self.alamofireService.get(
            with: requestDTO,
            url: BaseURLs.unsplash + "photos",
            headers: [
                "Content-Type": "application/json"
            ]
        ).map { data in
            switch data {
            case .success(let responseData):
                let responseDTO = try JSONDecoder().decode([PhotoListResponseDTO].self, from: responseData)
                return responseDTO.map { $0.toDomain() }
                
            case .failure(let error):
                throw error
            }
        }
    }
}
