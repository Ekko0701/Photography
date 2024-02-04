## Photography (24.02.02 Fri ~ 24.02.04 Sun)

- Architecture: Clean Architecture & MVVM  
<p align="left">
<img width="323" alt="스크린샷 2024-02-04 오후 11 16 54" src="https://github.com/Ekko0701/Photography/assets/108163842/28c52afb-19ca-4d8a-a597-b041fc9ce2cb">
<img width="309" alt="스크린샷 ![Uploading 스크린샷 2024-02-04 오후 11.16.30.png…]()
2024-02-04 오후 11 14 21" src="https://github.com/Ekko0701/Photography/assets/108163842/1a816396-538b-4072-bcbc-3e49773d872f">  
</p>  

- Dependency Management: Swift Package Manager  
- Library: RxSwift, RxCocoa, Alamofire, Nuke, Realm, Shuffle, Snapkit, CHTCollectionViewWaterfallLayout  


## 프로젝트 구조
Presentaion Layer: View, ViewModel  
DataLayer: Repository, Service(Network & Realm)  
Domain: Usecase, Model(Entity)  

## Description. 
- CleanArchitecture의 Dependency Rule 준수
        - Presentation Layer -> Domain Layer <- Data 레이어
        - 의존성 주입 패턴 사용
- Entity: Photo, PhotoDetail가 ViewModel과 차이가 적어 ViewModel로 사용
    ```swift
    struct Photo {
        let imageName: String
        let description: String
        let height: CGFloat
        let width: CGFloat
        let imageURL: String
    }
    ```
- Infrastructure의 AlamofireNetworkServices, RealmServices에서 각각 제네릭을 사용해 관련 로직을 구현해 놓음. 유연하게 사용 가능
  ```swift
  // DefaultRealmService.swift
  func create<T: Object>(object: T) {
      let realm = try! Realm()
      try! realm.write {
      realm.add(object)
      }
  }
  ```
- Repository 인터페이스를 사용해 각 Usecase에서 필요한 Repository에 접근해 사용 (의존성 역전)
  ```swift
  protocol PhotoListRepository {
      // 이미지 목록 요청
      func fetchPhotoLists(
          page: Int,
          perPage: Int
  ) -> Observable<[Photo]>
    
    // 이미지 상세 정보 요청
      func fetchPhotoDetail(
          id: String
    ) -> Observable<PhotoDetail>
  }
    ```

- RxSwift, RxCocoa를 사용해 View와 ViewModel을 바인딩
    - Input, Output, Transform 구조 사용
    ```swift
      struct Input {
            let viewWillAppear: Observable<Void>
            let bookmarkButtonTapped: PublishRelay<Void>
        }
        
      struct Output {
            var didLoadData = PublishRelay<Bool>()
            var presentDetailView = PublishRelay<String>()
        }
    
      func transform(
            from input: Input,
            disposeBag: DisposeBag
        ) -> Output { ... }
    ```
        
- SnapKit을 사용해 AutoLayout을 구현
- Realm을 사용해 Local 즐겨찾기 기능 구현
    - Realm Object
    <img width="600" alt="스크린샷 2024-02-05 오전 12 00 41" src="https://github.com/Ekko0701/Photography/assets/108163842/f90483a1-8289-4f05-82de-765b449db096">

- Nuke를 사용해 이미지 로드 구현
    - NukeExtensions.loadImage의 completionHander를 통해 각 cell의 이미지 로드중 indicator 노출
      ```swift
      self.loadingIndicator.startAnimating()
      NukeExtensions.loadImage(
          with: URL(string: photo.imageURL),
          options: ImageLoadingOptions(placeholder: UIImage(), transition: .fadeIn(duration: 0.33)),
          into: imageView,
          completion: { [weak self] _ in
          self?.loadingIndicator.stopAnimating()
          }
      )
      ```

### Data flow
1. View, ViewModel 바인딩
2. ViewModel에 View로 부터 Input이 발생, ViewModel에서 Usecase 실행
3. Use case에서 Repository의 메서드 호출
4. Repository에서 api 응답 결과 및 realm 데이터 반환
5. 반환된 데이터 View에 전달

#### Home Scene
<img src="https://github.com/Ekko0701/Photography/assets/108163842/5d76ee51-c0fd-4b0a-86ed-9d9f561e7f4c" width="200">
<img src="https://github.com/Ekko0701/Photography/assets/108163842/3b8b5609-b5b8-48e9-9440-55002b55384a" width="200">
<img src="https://github.com/Ekko0701/Photography/assets/108163842/6be05714-0751-4f0c-b6a5-f31d7a9b500a" width="200">

* /photos API 응답으로 받아온 이미지의 Width, Height 값으로 비율을 계산해 UICollectionViewCell 사이즈 설정
* UICollectionView가 최하단으로 스크롤 되면 Page 파라미터를 증가시켜 API 요청
* 각 Cell의 Image 로딩 중 LoadingIndicator 활성화
* UICollectionViewCell 탭 시 해당 이미지 PhotoDetail Scene Present

#### RandomPhoto Scene
<img src="https://github.com/Ekko0701/Photography/assets/108163842/7db9619d-c096-4682-8a95-4b383f9768e3" width="200">  
<img src="https://github.com/Ekko0701/Photography/assets/108163842/d32df4ee-1587-4360-a034-20b9a2dc0122" width="200">

* /photos/random API 응답으로 초기 6개 이미지 로딩
* Shuffle Library로 Left, Right Swipe 기능 구현
* 카드가 스와이프 될 때마다 /photos/random API 요청해 배열에 새로운 이미지 1개씩 추가 (무한 스와이프)
* "X" 버튼 탭 시 좌로 스와이프, 사진 배열에서 제거 
* "Bookmark" 버튼 탭 시 우로 스와이프 동시에 Realm DB에 추가 및 사진 배열에서 제거 
* "Info" 버튼 탭 시 해당 사진 PhotoDetail Scene Present

#### PhotoDetail Scene
<img src="https://github.com/Ekko0701/Photography/assets/108163842/25954b24-ace0-4328-ae35-d15cc6ec16fd" width="200">
<img src="https://github.com/Ekko0701/Photography/assets/108163842/6402ed9a-f560-42ff-83e7-83f08efaeeb6" width="200">
<img src="https://github.com/Ekko0701/Photography/assets/108163842/41963ba5-f99d-49ca-b1b8-75b54e1631ac" width="200">


* PhotoDetailViewController Present 방식
```swift
private func presentDetailViewController(with photoID: String) {
    let photoDetailViewModel = PhotoDetailViewModel(photoID: photoID, photoDetailUseCase: DefaultPhotoDetailUseCase(
        photoRepository: DefaultPhotoListRepository(alamofireService: DefaultAlamofireNetworkService()),
        realmRepository: DefaultRealmRepository(realmService: DefaultRealmService()))
    )
    
    let detailViewController = PhotoDetailViewController(viewModel: photoDetailViewModel)
    detailViewController.modalPresentationStyle = .overFullScreen
    self.present(detailViewController, animated: true)
}
```
* PhotoDetailViewModel 생성 시 받은 id 값으로 /photo/:id API 호출
* 진입 시 Realm DB에서 해당 id 값이 있으면 북마크 버튼 isSelected 상태로 변경
* 북마크 버튼 탭 시 북마크 상태였다면 북마크에서 제거, 북마크 상태가 아니었다면 북마크 추가
  - 북마크 상태 변경 후 홈 화면으로 돌아가면 바로 반영
  
## 추가
(24.02.04, 12:15) 사진 상세 화면 북마크 삭제 기능 수정 완료

## GIT COMMIT MESSAGE CONVENTION

|태그 이름|설명|
|:---:|:---|
|feat|새로운 기능을 추가할 경우|
|fix|버그를 고친 경우|
|ui|CSS 등 사용자 UI 디자인 변경|
|!BREAKING CHANGE|커다란 API 변경의 경우|
|!HOTFIX|급하게 치명적인 버그를 고쳐야하는 경우|
|style|코드 포맷 변경, 세미콜론 누락, 코드 수정이 없는 경우|
|refactor|프로덕션 코드 리팩토링|
|comment|필요한 주석 추가 및 변경|
|docs|문서를 수정한 경우|
|test|테스트 추가, 테스트 코드 리팩토링(프로덕션 코드 변경 X)|
|chore|빌드 테스트 업데이트, 패키지 매니저를 설정하는 경우(프로덕션 코드 변경 X)|
|rename|파일 혹은 폴더명을 수정하거나 옮기는 작업에 경우|
|remove|파일을 삭제하는 작업만 수행한 경우|
