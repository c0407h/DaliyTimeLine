//
//  MainTabbarController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabbarController: UITabBarController {
    
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureTabbar(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureTabbar()
        fetchUser()
        configureUI()
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("ASdf")
//        }
    }
    
    
    //MARK: - API
    func fetchUser() {        
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let displayName = Auth.auth().currentUser?.displayName else { return }
        guard let photoURL = Auth.auth().currentUser?.photoURL else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        let user = User(email: email, fullname: displayName, profileImageUrl: photoURL, username: displayName, uid: uid)
        self.user = user
        
//        UserService.fetchUser(withUid: currentUser.uid) { user in
//            self.user = user
//        }
    }
    
    func configureTabbar(user: User) {
        let mainListController = MainListViewController()
        mainListController.tabBarItem.tag = 0
        mainListController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName:  "calendar"), selectedImage: nil)
        
        let uploadViewController = UploadContentViewController()
        uploadViewController.tabBarItem.tag = 1
        
        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "calendar"), selectedImage: nil)
        profileController.tabBarItem.tag = 2
        
        viewControllers = [mainListController, uploadViewController, profileController]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        self.delegate = self
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancel in
            
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                guard let user = self.user else { return }
                let controller = UploadContentViewController()
                controller.selectedImage = selectedImage
//                controller.delegate = self
                controller.currentUser = user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.tintColor = .black
                self.present(nav, animated: false)
            }
        }
        
    }
}


extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(viewController.tabBarItem.tag)
        
        if viewController is UploadContentViewController {
            //            let vc = UploadContentViewController()
            //
            //            self.present(vc, animated: true)
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
            
            return false
        } else {
            return true
        }
        
    }
}
