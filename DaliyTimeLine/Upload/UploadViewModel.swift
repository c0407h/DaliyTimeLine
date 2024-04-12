//
//  UploadViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class UploadViewModel {
    var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
    var originalImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var selectedImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var mergeImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var caption: BehaviorRelay<String> = BehaviorRelay(value: "")
    var characterCount: Observable<Int> {
        return caption.map { $0.count }
    }
    
    private let disposeBag = DisposeBag()
    
    private let textMaxCount = 100
    
    init(currentUser: User? = nil, originalImage: UIImage? = nil, selectedImage: UIImage? = nil) {
        self.currentUser.accept(currentUser)
        self.originalImage.accept(originalImage)
        self.selectedImage.accept(selectedImage)
    }
    
    func uploadPost() -> Observable<Void> {
        return Observable.create { observer in
            guard let user = self.currentUser.value, let image = self.mergeImage.value else {
                observer.onError(UploadError.invalidData)
                return Disposables.create()
            }
            
            UploadService.uploadPost(caption: self.caption.value, image: image, user: user)
                .subscribe(onNext: { _ in
                    observer.onNext(())
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func textMaxLength(textCnt: Int, completion: @escaping() -> Void) {
        if textCnt > textMaxCount {
            completion()
        }
    }
    
}
