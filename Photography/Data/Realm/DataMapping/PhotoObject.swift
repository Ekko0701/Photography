//
//  RealmRequestDTO.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RealmSwift

class PhotoObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageURL: String
    @Persisted var width: Float
    @Persisted var height: Float
}

extension PhotoObject {
    func toDomain() -> Photo {
        return Photo(
            imageName: id,
            description: "",
            height: CGFloat(height),
            width: CGFloat(width),
            imageURL: imageURL
        )
    }
}
