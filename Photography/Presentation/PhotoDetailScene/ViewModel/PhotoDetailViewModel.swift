//
//  PhotoDetailViewModel.swift
//  Photography
//
//  Created by Ekko on 2/4/24.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

final class PhotoDetailViewModel {
    private let photoDetailUseCase: PhotoDetailUseCase
    private let photoID: String
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        var didLoadPhotoDetail: Driver<PhotoDetail>
    }
    
    init(
        photoID: String,
        photoDetailUseCase: PhotoDetailUseCase
    ) {
        self.photoID = photoID
        self.photoDetailUseCase = photoDetailUseCase
    }
    
    func transform(
        from input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let photoDetailDriver = input.viewDidLoad
            .flatMap { [unowned self] _ in
                return self.photoDetailUseCase.fetchPhotoDetail(from: self.photoID)
            }.asDriver(onErrorJustReturn: PhotoDetail(id: "nil", slug: "nil", title: "nil", width: 0, height: 0, imageURL: "", description: "nil", userName: "nil", tags: []))
        
        let output = Output(didLoadPhotoDetail: photoDetailDriver)
        
        return output
    }
}
