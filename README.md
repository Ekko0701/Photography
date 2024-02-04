## Photography (24.02.02 Fri ~ )

Architecture: Clean Architecture & MVVM  
Dependency Management: Swift Package Manager  
Library: RxSwift, RxCocoa, Alamofire, Nuke, Realm, Shuffle, Snapkit, CHTCollectionViewWaterfallLayout  

## 프로젝트 구조
Presentaion Layer: View, ViewModel  
DataLayer: Repository, Service(Network & Realm)  
Domain: Usecase, Model(Entity)  

## Description. 
    - Entity: Photo, PhotoDetail가 ViewModel과 차이가 적어 ViewModel로 사용
    - Infrastructure의 AlamofireNetworkServices, RealmServices에서 각각 제네릭을 사용해 관련 로직을 구현해 놓음. 유연하게 사용 가능
    - Repository 인터페이스를 사용해 각 Usecase에서 필요한 Repository에 접근해 사용 (의존성 역전)
        - 처음엔 기능 개발이 오래 걸렸지만 후반에는 중복된 기능이 Repository에 이미 정의되있어 재사용성이 올라감

    - RxSwift, RxCocoa를 사용해 View와 ViewModel을 바인딩
    - SnapKit을 사용해 AutoLayout을 구현
    - Realm을 사용해 즐겨찾기 기능 구현
    
    - CHTCollectionViewWaterfallLayout 라이브러리를 사용해 Pinterest 스타일의 레이아웃 구현
    - Shuffle 라이브러리를 사용해 RandomPhotoView 레이아웃 구성
    
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
