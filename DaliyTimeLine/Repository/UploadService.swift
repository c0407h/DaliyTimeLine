//
//  UploadService.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import UIKit
import Firebase
import FirebaseStorage

typealias FirestoreCompletion = (Error?) -> Void

struct UploadService {
    static func uploadPost(caption: String, image: UIImage, user: User, compltion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption, "timestamp": Timestamp(date: Date()), "imageUrl": imageUrl, "ownerUid": uid, "ownerUsername": user.username as Any] as [String : Any]
            
                    
            let docRef = COLLECTION_CONTENTS.addDocument(data: data, completion: compltion)
            
            
            COLLECTION_USERS.document(uid).collection("user-feed").document(docRef.documentID).setData([:])
            
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

