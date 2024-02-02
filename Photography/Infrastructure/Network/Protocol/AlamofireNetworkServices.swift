//
//  AlamofireNetworkServices.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift
import Alamofire

protocol AlamofireNetworkService {
    func get(
        url urlString: String,
        headers: HTTPHeaders?
    ) -> Observable<Result<Data, NetworkError>>
    
    func get<T: Encodable>(
        with bodyData: T,
        url urlString: String,
        headers: HTTPHeaders?
    ) -> Observable<Result<Data, NetworkError>>
}
