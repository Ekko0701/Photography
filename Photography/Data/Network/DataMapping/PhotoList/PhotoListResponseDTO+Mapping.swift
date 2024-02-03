//
//  PhotoListResponseDTO+Mapping.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation
/// 사진 리스트 응답 DTO
struct PhotoListResponseDTO: Codable {
    
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
    let urls: URLS
    let links: PhotoLinks
    let likes: Int
    let likedByUser: Bool
}

// 사진 URLS
struct URLS: Codable {
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

// 사진 링크
struct PhotoLinks: Codable {
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

// 프로필 이미지
struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

// MARK: - To domain
extension PhotoListResponseDTO {
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
