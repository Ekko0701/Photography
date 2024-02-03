//
//  RandomPhotosRequestDTO.swift
//  Photography
//
//  Created by Ekko on 2/3/24.
//

import Foundation

// MARK: Random Photos 요청 DTO
struct RandomPhotosRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case key = "client_id"
        case count
    }
    
    let key: String
    let count: Int
}
