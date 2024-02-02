//
//  NetworkError.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

/// 네트워크 통신 에러 타입
enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}
