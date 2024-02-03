//
//  RealmService.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import Realm
import RealmSwift
import RxSwift

protocol RealmService {
    func create<T: Object>(object: T)
    func read<T: Object>(id: String) -> Observable<T>
    func readAll<T: Object>() -> Observable<[T]>
    func delete<T: Object>(object: T)
}
