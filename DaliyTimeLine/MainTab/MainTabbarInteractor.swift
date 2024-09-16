//
//  MainTabbarInteractor.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import Foundation
import FirebaseAuth

protocol MainTabbarInteractorProtocol: AnyObject {
    func getUser() -> User?
}

class MainTabbarInteractor: MainTabbarInteractorProtocol {
    weak var presenter: MainTabbarPresenterProtocol?

    func getUser() -> User? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        guard let email = currentUser.email else { return nil }
        
        let user = User(email: email, fullname: currentUser.displayName, profileImageUrl: currentUser.photoURL, username: currentUser.displayName, uid: currentUser.uid)
         
        return user
    }
}
