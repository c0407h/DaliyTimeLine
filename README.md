# DailyTimeLine

앱스토어 링크 : https://apps.apple.com/kr/app/dailytimeline/id6478968261<br>
노션에서 보기 : https://important-card-5e8.notion.site/DailyTimeLine-98ca7fbf59044bc7b7ebc066ea6844f6?pvs=4<br>
---

## 스크린샷
|||||||
|:---:|:---:|:---:|:---:|:---:|:---:|
|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/d69f4836-2d11-472f-939a-143f56278a1e)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/05e9bf1b-262d-47fa-b0bd-0c039cd121ad)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/9b826a14-b700-4247-9451-af30ebd8c4bf)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/857348f7-e850-4811-a150-c1335afc61db)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/5f24d74f-1104-4e38-bf18-76d673a51ae7)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/60bc3990-41b1-4f85-a423-2bbcf29328f1)|


--- 
## 1.개요
- 하루의 일을 사진과 내용으로 기록하는 기록용 어플입니다.
    - 포스트 등록시 날자와 시간이 사진과 합성됩니다.
    - 사진 외 100글자이내로 글도 등록할 수 있습니다.
    - 포스트 기록 시 날자와 합성된 사진을 자동으로 사진첩에 저장할 수 있습니다.
    - 남들에게 보여주기 싫다면 화면 잠금을 이용하여 화면 잠금을 사용할 수 있습니다.
    - 어떤 조건 없이 오운완, 데이트, 식단 등등 뭐든지 기록해보세요.
- 사진을 촬영하거나 사진첩에 있는 사진을 선택하여 업로드 할 수 있습니다.
- 애플, 구글 SNS 로그인을 사용하여 로그인할 수 있습니다.
## 2.주요기능
- SnapKit을 활용하여 코드로 전체적인 UI 구현
- 생체 인식 및 비밀번호를 사용한 화면 잠금 기능 구현
- Firebase를 활용하여 로그인 및 포스트 업로드/삭제/수정 기능 구현
- RxSwift를 이용한 UI 반응형 처리

### - 상세설명

- 사용 기술
    - Swift
    - SnapKit - SnapKit을 사용하여 간결하게 코드로 레이아웃을 구현하였습니다.
    - Kingfisher - 이미지 재접근시 이미지 로딩시간 단축을 위하여 사용하였습니다.
    - YPImagePicker - 포스트 작성시 사진 필터 기능 사용을 위해 사용하였습니다.
    - Firebase - SNS로그인 및 서버가 없는 관계로 Firebase로 백엔드 서비스를 대체 하였습니다.
    - FSCalendar - 달력구현을 위하여 사용하였습니다.
    - RxSwift - UI 반응형 처리 및 코드 가독성을 위하여 사용하였습니다.


- `LocalAuthentication` 를 활용하여 화면잠금을 위한 비밀번호 설정시 FaceId 사용
    - 비밀번호와 생체 인증을 활용하여 둘중 하나만으로 화면 잠금을 해제 할 수 있도록 구현하였습니다.
    ```swift
    //로그인 시
    self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "잠금을 위해 인증을 해주세요.") { success, error in
    if success {
        DispatchQueue.main.async {
            self.delegate?.goToMain()
            self.dismiss(animated: true)
        }
        
    } 
    }

    //잠금 설정시
    self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "잠금을 위해 인증을 해주세요.") { success, error in
        if let error = error {
            DispatchQueue.main.async {
                print(error.localizedDescription, error)
                self.dismiss(animated: true)
            }
        }
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            
        }
    }
    ```
- 포스트(사진, 내용) 데이터를 저장하는 기능
    - firebase Storage putData, 업로드 addDocument(data:)를 활용하여 이미지 데이터, 포스트 데이터 업로드
    ```swift
    func putData(_ uploadData: Data,
                        metadata: StorageMetadata? = nil,
                        completion: ((_: StorageMetadata?, _: Error?) -> Void)?) -> StorageUploadTask
                        
    if let imageUrl = url?.absoluteString {
            let data: [String: Any] = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "imageUrl": imageUrl,
                "ownerUid": uid,
                "ownerUsername": user.username as Any
            ]
            
            let docRef = COLLECTION_CONTENTS.addDocument(data: data) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            
            COLLECTION_USERS.document(uid).collection("user-feed").document(docRef.documentID).setData([:])
        } else if let error = error {
            observer.onError(error)
        }
    ```
- 포스트 데이터 요청 기능
    - timestamp와 userUid로 필터 후 getDocuments 활용하여 해당날자에 맞는 데이터 요청 기능
    ```swift
    func getPost(date: Date, completion: @escaping([Post]) -> Void) {
    let calendar = Calendar.current
    let startDate = calendar.startOfDay(for: date) // 오늘 날짜의 시작
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)! // 오늘 날짜의 다음 날의 시작
    
    Firestore.firestore().collection("contents")
        .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
        .whereField("timestamp", isLessThan: Timestamp(date: endDate))
        .whereField("ownerUid", isEqualTo: Auth.auth().currentUser?.uid as Any)
        .getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return } // document들을 가져옴
            
            let posts = documents.map{
                Post(documentId: $0.documentID,dictionary: $0.data())
            }
            
            completion(posts)
        }
}
    ```

## 3.트러블슈팅
- 텍스트와 사진 합성시 텍스트위치가 이미지 사이즈에 따라 위치가 달라지며 사이즈도 변하는 이슈 발생
    - label을 추가하여 위치와 사이즈를 고정하고 view를 캡쳐하는 방식으로 변경하였습니다.
    
|변경 전|변경 후|
|:---:|:---:|
|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/6817bcb8-899c-4fbf-8a95-c7a41bef0bb0)|![](https://github.com/iOS-Ruel/DaliyTimeLine/assets/67133244/43711cae-df61-43d6-9880-2330de893311)|

## 4.고민점
- RxSwift를 사용함에 있어 ```Subject```를 사용하여 특정 상황에서 api를 재 호출해야할 경우 ViewModel의 메서드를 호출을 아래와 같이 하는지에 대한 의문
```swift
extension MainListViewController: MainListViewControllerDelegate {
  func reload() {
      viewModel.rxGetPost(date: Date())
      self.calendarView.select(Date())
      self.calendarView.reloadData()
  }
}

//ViewModel
var dailyPost = PublishSubject<[Post]>()

func rxGetPost(date: Date) {
    service.getPost(date: date) { post in
        self.dailyPost.onNext(post)
        self.dailyPostCount.onNext(post.count)
        
    }
}
```
- MainListViewController에서 ```dailyPost```를 ```subscribe```하고 있기 때문에 ```rxGetPost``` 메서드를 호출하여 ```dailyPost```에 ```onNext```를 해주는 과정을 통해 원하는 결과를 얻을 수 있었음<br>
그러나 위와 같은 방식으로 RxSwift를 사용하는지에 대한 고민이 더 필요할 것 같고 더 많은 사용을 하며 느껴봐야할 것 같다.

## 5.개선사항
1. ⭐️ 현재 너무 밋밋한 색상과 디자인으로 디자인 수정에 대한 필요
2. 포스트 전체 보기 기능 추가 
3. RxSwift 코드에 대한 개선
4. 포스트 등록시 날짜 위치 변경 기능 추가 필요
## 6.회고
1. SnapKit을 이용하여 코드 베이스로 UI를 구현하였는데 한 파일에서 모든 Component의 구성을 하려 하니 코드가 길어지고 가독성이 좋지 않게 되었다. View를 따로 분리하면 해결책이 되겠지만, 코드로 작성하지 않고 Xib 기반으로 UI를 그린다면 더 가독성이 좋지 않을까라는 생각을 하였다.
    - 다만 혼자 이 프로젝트를 진행하면서 위와 같이 생각을 하였지만, 이전 협업 과정 중 서로 Xib를 만질경우 충돌의 우려가 상당했었다. 이러한 이유로 협업을 하는 상황이라면 코드베이스로 UI를 구현하는 것이 충돌의 우려를 줄일 것이라고 다시 한번 생각하게 되었다. 이로 인해 지속적으로 SnapKit을 사용하지 않을까 생각된다.
2. 디자인의 중요성을 다시한번 깨달았다. 디자인은 안중에도 없이 기능 구현을 먼저 하다 보니 참으로 하얗다라는 생각이 들었다. 지속적으로 개인적으로 프로젝트를 진행하게 되더라도 디자인적인 부분의 고려가 충분히 필요할 것 같다.
3. RxSwift를 학습하고 학습을 해도 사실 매번 헷갈린다.. RxSwif를 사용하면서도 이게 맞나? 라는 생각을 하며 코드를 작성하게 되는데 이러한 부분이 적어질 수 있도록 지속적인 학습도 필요하겠지만, 꾸준히 RxSwift를 사용하면서 개발을 진행해 봐야할것 같다.
## 7.리젝사유
- **Guideline 5.1.1 - Legal - Privacy - Data Collection and Storage**
    - 권한 요청시 문구가 명확하지 않아 리젝