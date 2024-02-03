//
//  PhotoDetailResponseDTO+Mapping.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

struct PhotoDetailResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, description, urls, user, tags
    }
    
    let id: String
    let slug: String
    let width: Float
    let height: Float
    let description: String?
    let urls: URLsDTO
    let user: User
    let tags: [Tag]
}

extension PhotoDetailResponseDTO {
    struct URLsDTO: Codable {
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
        
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
        let smallS3: String?
    }
    
    struct User: Decodable {
        let username: String
        let name: String
    }
    struct Tag: Decodable {
        let title: String
    }
}

extension PhotoDetailResponseDTO {
    func toDomain() -> PhotoDetail {
        return PhotoDetail(
            id: id,
            slug: slug,
            title: "",
            width: width,
            height: height,
            imageURL: urls.regular,
            description: description ?? "",
            userName: user.name,
            tags: tags.map { $0.title }
        )
    }
}
