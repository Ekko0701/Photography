//
//  DefaultAlamofireNetworkService.swift
//  Photography
//
//  Created by Ekko on 2/2/24.
//

import Foundation

import RxSwift
import Alamofire

final class DefaultAlamofireNetworkService: AlamofireNetworkService {
    func get(
        url urlString: String,
        headers: HTTPHeaders?
    ) -> Observable<Result<Data, NetworkError>> {
        return self.request(url: urlString, headers: headers, method: .get)
    }
    
    func get<T: Encodable>(
        with bodyData: T,
        url urlString: String,
        headers: HTTPHeaders?
    ) -> Observable<Result<Data, NetworkError>> {
        return self.request(with: bodyData, url: urlString, headers: headers, method: .get)
    }
    
    /// Default request
    private func request(
        url urlString: String,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod
    ) -> Observable<Result<Data, NetworkError>> {
        // URL 생성
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.urlGeneration)
        }
        
        return Observable<Result<Data, NetworkError>>.create { emitter in
            let request = AF.request(url, method: method, headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        emitter.onNext(.success(data))
                        emitter.onCompleted()
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            emitter.onNext(.failure(.error(statusCode: statusCode, data: response.data)))
                        } else {
                            emitter.onNext(.failure(.generic(error)))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    /// Request with body data
    private func request<T: Encodable>(
        with bodyData: T,
        url urlString: String,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod
    ) -> Observable<Result<Data, NetworkError>> {
        // URL 생성
        guard let url = URL(string: urlString) else {
            return Observable.error(NetworkError.urlGeneration)
        }
        
        return Observable<Result<Data, NetworkError>>.create { emitter in
            let request = AF.request(url,
                                     method: method,
                                     parameters: bodyData,
                                     headers: headers)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        emitter.onNext(.success(data))
                        emitter.onCompleted()
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            emitter.onNext(.failure(.error(statusCode: statusCode, data: response.data)))
                        } else {
                            emitter.onNext(.failure(.generic(error)))
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
