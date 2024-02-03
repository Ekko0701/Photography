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
}

extension PhotoObject {
    func toDomain() -> Photo {
        return Photo(imageName: id, description: "", height: 0, width: 0, imageURL: imageURL)
    }
}
