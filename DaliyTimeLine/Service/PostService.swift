//
//  PostService.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/5/24.
//

import Foundation
import Firebase
import RxSwift
import FirebaseFirestoreInternal

class PostService {
    
    func rxGetPost(date: Date) -> Observable<[Post]> {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date) // 오늘 날짜의 시작
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)! // 오늘 날짜의 다음 날의 시작
        
        return Observable.create { observer in
            COLLECTION_CONTENTS
                .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
                .whereField("timestamp", isLessThan: Timestamp(date: endDate))
                .whereField("ownerUid", isEqualTo: Auth.auth().currentUser?.uid as Any)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("DEBUG: \(error.localizedDescription)")
                        observer.onError(error)
                    }
                    
                    guard let documents = snapshot?.documents else { return } // document들을 가져옴
                    
                    let posts = documents.map{
                        Post(documentId: $0.documentID,dictionary: $0.data())
                    }
                    
                    observer.onNext(posts)
                }
            return Disposables.create()
        }
    }
    
    func rxGetAllPosts() -> Observable<[Post]> {
        return Observable.create { observer in
//            COLLECTION_CONTENTS
//                .whereField("ownerUid", isEqualTo: Auth.auth().currentUser?.uid as Any)
//                .getDocuments { snapshot, error in
//                    if let error = error {
//                        print("DEBUG: \(error.localizedDescription)")
//                        observer.onError(error)
//                    }
//                    
//                    guard let documents = snapshot?.documents else { return } // document들을 가져옴
//                    let posts = documents.map{ Post(documentId: $0.documentID, dictionary: $0.data())}
//                    
//                    observer.onNext(posts)
//                }
//            return Disposables.create()
            guard let currentUserUid = Auth.auth().currentUser?.uid else {
                       
                       return Disposables.create()
                   }
                   
                   let query = COLLECTION_CONTENTS
                       .whereField("ownerUid", isEqualTo: currentUserUid)
                   
                   let listener = query.addSnapshotListener { snapshot, error in
                       if let error = error {
                           print("DEBUG: \(error.localizedDescription)")
                           observer.onError(error)
                           return
                       }
                       
                       guard let documents = snapshot?.documents else { return } // document들을 가져옴
                       let posts = documents.map { Post(documentId: $0.documentID, dictionary: $0.data()) }
                       observer.onNext(posts)
                   }
                   
                   return Disposables.create {
                       listener.remove()
                   }
        }
    }
    
    func deletePost(documentID: String) -> Observable<Bool> {
        return Observable.create { observer in
            COLLECTION_CONTENTS.document(documentID).delete() { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func updatePost(documentID: String, caption: String) -> Observable<Bool> {
        return Observable.create { observer in
            COLLECTION_CONTENTS.document(documentID).updateData(["caption": caption]) { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
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
    
    func getAllPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_CONTENTS
            .whereField("ownerUid", isEqualTo: Auth.auth().currentUser?.uid as Any)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return } // document들을 가져옴
                let posts = documents.map{ Post(documentId: $0.documentID, dictionary: $0.data())}
                
                completion(posts)
            }
    }
    
    
}
