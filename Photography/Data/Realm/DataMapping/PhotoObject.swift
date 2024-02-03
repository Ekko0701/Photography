//
//  RealmRequestDTO.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RealmSwift

class RealmPhotoDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageURL: String
}
