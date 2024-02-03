//
//  PhotoListRequestDTO.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

// MARK: - PhotoList 요청 DTO
struct PhotoListRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case key = "client_id"
        case page
        case perPage = "per_page"
    }
    
    let key: String
    let page: Int
    let perPage: Int
}
