//
//  PhotoDetail.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

struct PhotoDetail {
    let id: String
    let slug: String
    let title: String
    let width: Float
    let height: Float
    let imageURL: String
    let description: String
    let userName: String
    let tags: [String]
}

extension PhotoDetail {
    func toPhoto() -> Photo {
        return Photo(
            imageName: id,
            description: description,
            height: CGFloat(height),
            width: CGFloat(width),
            imageURL: imageURL
        )
    }
}
