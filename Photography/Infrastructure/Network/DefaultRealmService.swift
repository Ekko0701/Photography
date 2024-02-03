//
//  DefaultRealmService.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import Realm
import RealmSwift
import RxSwift

final class DefaultRealmService: RealmService {
    func create(T: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(T)
        }
    }
    
    func read<T: Object>(id: String) -> Observable<T> {
        let realm = try! Realm()
        let object = realm.object(ofType: T.self, forPrimaryKey: id)
        guard let object = object else {
            return Observable.error(RealmError.notFound)
        }
        return Observable.just(object)
    }
    
    func readAll<T: Object>() -> Observable<[T]> {
        let realm = try! Realm()
        let objects = realm.objects(T.self)
        return Observable.just(Array(objects))
    }
    
    func delete<T: Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
}
