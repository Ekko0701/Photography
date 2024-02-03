//
//  RealmError.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

enum RealmError: Error {
    case notFound
    case generic(Error)
}
