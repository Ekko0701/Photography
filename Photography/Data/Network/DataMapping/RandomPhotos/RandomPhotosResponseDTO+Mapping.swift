//
//  RandomPhotosResponseDTO+Mapping.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation
/// 사진 리스트 응답 DTO
struct RandomPhotosResponseDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, slug, width, height, color, description, urls, links, likes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case blurHash = "blur_hash"
        case altDescription = "alt_description"
        case likedByUser = "liked_by_user"
    }
    
    let id: String
    let slug: String?
    let createdAt: String?
    let updatedAt: String?
    let promotedAt: String?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String?
    let description: String?
    let altDescription: String?
    let urls: URLsDTO
    let links: PhotoLinksDTO
    let likes: Int
    let likedByUser: Bool
}

extension RandomPhotosResponseDTO {
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
    
    struct PhotoLinksDTO: Codable {
        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html, download
            case downloadLocation = "download_location"
        }
        
        let selfLink: String
        let html: String
        let download: String
        let downloadLocation: String
    }
}

// 사진 URLS


// MARK: - To domain
extension RandomPhotosResponseDTO {
    func toDomain() -> Photo {
        return Photo(
            imageName: self.id,
            description: self.description ?? "",
            height: CGFloat(self.height),
            width: CGFloat(self.width),
            imageURL: self.urls.regular
        )
    }
}
