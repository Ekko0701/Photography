//
//  PhotoDetailRequestDTO.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

struct PhotoDetailRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case key = "client_id"
    }
    let key: String
}
