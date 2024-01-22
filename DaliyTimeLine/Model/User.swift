//
//  User.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/22/24.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullname: String
    let profileImageUrl: URL
    let username: String
    let uid: String
    
//    var isFollowed = false

//    var stats: UserStats!
    
    //현재사용자인지 상대방인지 확인하는 프로퍼티
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}
    
    init(email: String, fullname: String, profileImageUrl: URL, username: String, uid: String) {
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.uid = uid
    }
    
//    init(dictionary: [String: Any]) {
//        self.email = dictionary["email"] as? String ?? ""
//        self.fullname = dictionary["fullname"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
//        self.username = dictionary["username"] as? String ?? ""
//        self.uid = dictionary["uid"] as? String ?? ""
////        self.stats = UserStats(followers: 0, following: 0, posts: 0)
//    }
    
    
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
