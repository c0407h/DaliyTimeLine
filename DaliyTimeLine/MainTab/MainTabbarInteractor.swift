//
//  MainTabbarInteractor.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import Foundation
import FirebaseAuth

protocol MainTabbarInteractorProtocol: AnyObject {
    func fetchUser()
    func getUser() -> User?
}

class MainTabbarInteractor: MainTabbarInteractorProtocol {
    private var currentUser: User?
    
    weak var presenter: MainTabbarPresenterProtocol?
    
    func fetchUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let email = currentUser.email else { return }
        
        let user = User(email: email, fullname: currentUser.displayName, profileImageUrl: currentUser.photoURL, username: currentUser.displayName, uid: currentUser.uid)
        
        presenter?.didFetchUser(user: user)
    }
    
    func getUser() -> User? {
        return currentUser
    }
}
