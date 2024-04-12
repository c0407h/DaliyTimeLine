//
//  PostDetailViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/9/24.
//

import Foundation
import RxSwift

struct PostDetailViewModel {
    var post: Post
    let service = PostService()
    
    private let textMaxCount = 100
    
    init(post: Post) {
        self.post = post
    }
    
    func rxDeletePost(documentID: String) -> Observable<Bool>{
        return service.deletePost(documentID: documentID)
    }
    
    func rxUpdatePost(documentId: String, caption: String) -> Observable<Bool>{
        return service.updatePost(documentID: documentId, caption: caption)
    }
    
    func textCheckMaxLength(textCount: Int, compltion: @escaping() -> Void) {
        if textCount > textMaxCount {
            compltion()
        }
        
    }
}
