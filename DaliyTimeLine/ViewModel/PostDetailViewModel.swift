//
//  PostDetailViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/9/24.
//

import Foundation


struct PostDetailViewModel {
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    func deletePost(documentID: String, completion: @escaping() -> Void) {
        COLLECTION_CONTENTS.document(documentID).delete() { error in
            if let _ = error {
                
            } else {
                completion()
            }
        }
    }
    
    func updatePost(documentID: String, caption: String,completion: @escaping() -> Void) {
        COLLECTION_CONTENTS.document(documentID).updateData(["caption": caption]) { error in
            if let _ = error {
                
            } else {
                completion()
            }
        }
    }
    
}
