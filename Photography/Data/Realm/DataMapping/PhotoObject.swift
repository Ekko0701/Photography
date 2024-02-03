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
    
    init(from photo: Photo) {
        super.init()
        self.id = photo.imageName
        self.imageURL = photo.imageURL
    }
}
