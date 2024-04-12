//
//  UploadService.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import UIKit
import Firebase
import FirebaseStorage
import RxSwift

typealias FirestoreCompletion = (Error?) -> Void

enum UploadError: Error {
    case invalidData
    case invalidImageData
}

struct UploadService {
    static func uploadPost(caption: String, image: UIImage, user: User) -> Observable<Void> {
        return Observable.create { observer in
            guard let uid = Auth.auth().currentUser?.uid else {
                observer.onError(UploadError.invalidData)
                return Disposables.create()
            }
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else {
                observer.onError(UploadError.invalidImageData)
                return Disposables.create()
            }
            
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/contents_images/\(filename)")
            
            ref.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                ref.downloadURL { url, error in
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
                }
            }
            
            return Disposables.create()
        }
    }
}

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        //이미지 업로드 데이터
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/contents_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Debug: failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
            
        }
    }
}

