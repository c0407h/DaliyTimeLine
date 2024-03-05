//
//  Post.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/5/24.
//

import Foundation
import Firebase

struct Post {
    let documentId: String
    var caption: String
    let imageUrl: String
    let ownerUid: String
    let ownerUsername: String
    let timestamp: Timestamp
    
    init(documentId: String, dictionary: [String: Any]) {
        self.documentId = documentId
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
    
}
