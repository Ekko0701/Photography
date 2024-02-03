//
//  DefaultRandomPhotosRepository.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation

import RxSwift

final class DefaultRandomPhotosRepository {
    private let alamofireService: AlamofireNetworkService
    
    init(alamofireService: AlamofireNetworkService) {
        self.alamofireService = alamofireService
    }
}

extension DefaultRandomPhotosRepository: RandomPhotosRepository {
    func fetchRandomPhotos(count: Int) -> Observable<[Photo]> {
        let requestDTO = RandomPhotosRequestDTO(
            key: UnSplashAPIKey.publicKey,
            count: count
            )
        
        return self.alamofireService.get(
            with: requestDTO,
            url: BaseURLs.unsplash + "photos/random",
            headers: [
                "Content-Type": "application/json"
            ]
        ).map { data in
            switch data {
            case .success(let responseData):
                let responseDTO = try JSONDecoder().decode([RandomPhotosResponseDTO].self, from: responseData)
                return responseDTO.map { $0.toDomain() }
            case .failure(let error):
                throw error
            }
        }
    }
}
