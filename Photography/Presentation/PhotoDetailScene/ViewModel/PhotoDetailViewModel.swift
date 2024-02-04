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
    private let photoDetailRelay = BehaviorRelay<PhotoDetail?>(value: nil)
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let closeButtonTapped: Observable<Void>
        let bookmarkButtonTapped: Observable<Bool>
    }
    
    struct Output {
        var didLoadPhotoDetail: Driver<PhotoDetail>
        var closeButtonTapped: Driver<Void>
        var isBookmarked: Driver<Bool>
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
        var fetehedphotoDetail: PhotoDetail
        
//        let photoDetailDriver = input.viewDidLoad
//            .flatMap { [unowned self] _ in
//                return self.photoDetailUseCase.fetchPhotoDetail(from: self.photoID)
//            }.asDriver(onErrorJustReturn: PhotoDetail(id: "nil", slug: "nil", title: "nil", width: 0, height: 0, imageURL: "", description: "nil", userName: "nil", tags: []))
        
        input.viewDidLoad
            .flatMapLatest { [unowned self] _ in
                self.photoDetailUseCase.fetchPhotoDetail(from: self.photoID)
            }
            .subscribe(onNext: { [weak self] photoDetail in
                self?.photoDetailRelay.accept(photoDetail) // 2. 패치한 PhotoDetail 데이터를 BehaviorRelay에 저장
            })
            .disposed(by: disposeBag)

        let photoDetailDriver = photoDetailRelay
            .asDriver()
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: PhotoDetail(id: "nil", slug: "nil", title: "nil", width: 0, height: 0, imageURL: "", description: "nil", userName: "nil", tags: []))
        
        let closeViewDriver = input.closeButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        let isBookMarkedDriver = input.viewDidLoad
            .flatMap { [unowned self] _ in
                return self.photoDetailUseCase.checkBookmark(from: self.photoID)
            }.asDriver(onErrorJustReturn: false)
        
        input.bookmarkButtonTapped
            .withLatestFrom(photoDetailRelay.asObservable()) { (isBookMarked, photoDetail) -> (Bool, PhotoDetail?) in
                           return (isBookMarked, photoDetail)
                       }
            .subscribe(onNext: { [weak self] (isBookMarked, photoDetail) in
                print("북마크 상태: \(isBookMarked)")
                guard let self = self else { return }
                // isBookMarked true면 등록
                // false면 해제
                if isBookMarked {
                    self.photoDetailUseCase.createBookmark(photo: photoDetail ?? PhotoDetail(id: self.photoID, slug: "", title: "", width: 0, height: 0, imageURL: "", description: "", userName: "", tags: []))
                } else {
//                    self.photoDetailUseCase.deleteBookmark(photo: photoDetail ?? PhotoDetail(id: self.photoID, slug: "", title: "", width: 0, height: 0, imageURL: "", description: "", userName: "", tags: []))
                }
            })
            .disposed(by: disposeBag)
        
        let output = Output(
            didLoadPhotoDetail: photoDetailDriver,
            closeButtonTapped: closeViewDriver,
            isBookmarked: isBookMarkedDriver
        )
        
        return output
    }
}
