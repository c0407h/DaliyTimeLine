//
//  MainTabbarController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import Firebase
import YPImagePicker
import FirebaseAuth

class MainTabbarController: UITabBarController {
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureTabbar(user: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configureUI()
    }
    
    
    //MARK: - API
    func fetchUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let email = currentUser.email else { return }
      
        let user = User(email: email, fullname: currentUser.displayName, profileImageUrl: currentUser.photoURL, username: currentUser.displayName, uid: currentUser.uid)
        self.user = user
    }
    
    func configureTabbar(user: User) {
        let mainListController = MainListViewController()
        mainListController.tabBarItem.tag = 0
        mainListController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName:  "calendar"), selectedImage: nil)
        
        let uploadViewController = UploadContentViewController(viewModel: UploadViewModel())
        uploadViewController.tabBarItem.tag = 1
        uploadViewController.tabBarItem.title = nil
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            uploadViewController.tabBarItem.image = UIImage(systemName:  "camera.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
        } else {
            uploadViewController.tabBarItem.image = UIImage(systemName:  "camera.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))?.withBaselineOffset(fromBottom: 25)
        }
    
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        settingViewController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape.fill"), selectedImage: nil)
        settingViewController.tabBarItem.tag = 2
        
        viewControllers = [mainListController, uploadViewController, settingViewController]
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        self.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabbarSetup()
    }
    
    func tabbarSetup() {
        self.tabBar.frame.size.height = 83
        self.tabBar.frame.origin.y = self.view.frame.height - 83
        self.tabBar.frame.origin.x = 0
        self.tabBar.frame.size.width = tabBar.bounds.width
        
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.cornerRadius = 24
        self.tabBar.layer.masksToBounds = true
        
        self.tabBar.itemPositioning = .fill
        self.tabBar.itemSpacing = self.tabBar.frame.width / 3
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = .black
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.barTintColor = .white
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancel in
            if cancel {
                picker.dismiss(animated: true)
            } else {
                picker.dismiss(animated: false) {
                    guard let selectedImage = items.singlePhoto?.image else { return }
                    guard let user = self.user else { return }
                    let controller = UploadContentViewController(viewModel: UploadViewModel(currentUser: user, originalImage: selectedImage, selectedImage: selectedImage))
                    
                    controller.delegate = self
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.tintColor = .black
                    self.present(nav, animated: false)
                }
            }
        }
    }    
}


extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is UploadContentViewController {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .photo
            config.screens = [.photo, .library]
            
            config.colors.tintColor = .darkGray
            config.library.maxNumberOfItems = 1
            
            config.fonts.pickerTitleFont =  UIFont(name: "OTSBAggroB", size: 17)!
            config.fonts.libaryWarningFont = UIFont(name: "OTSBAggroM", size: 14)!
            config.fonts.durationFont = UIFont(name: "OTSBAggroM", size: 12)!
            config.fonts.multipleSelectionIndicatorFont = UIFont(name: "OTSBAggroM", size: 12)!
            config.fonts.albumCellTitleFont = UIFont(name: "OTSBAggroM", size: 16)!
            config.fonts.albumCellNumberOfItemsFont = UIFont(name: "OTSBAggroM", size: 12)!
            config.fonts.menuItemFont = UIFont(name: "OTSBAggroL", size: 12)!
            config.fonts.filterNameFont = UIFont(name: "OTSBAggroM", size: 11)!
            config.fonts.filterSelectionSelectedFont = UIFont(name: "OTSBAggroL", size: 11)!
            config.fonts.filterSelectionUnSelectedFont = UIFont(name: "OTSBAggroM", size: 11)!
            config.fonts.cameraTimeElapsedFont = UIFont(name: "OTSBAggroM", size: 13)!
            config.fonts.navigationBarTitleFont = UIFont(name: "OTSBAggroM", size: 17)!
            config.fonts.rightBarButtonFont = UIFont(name: "OTSBAggroL", size: 17)
            config.fonts.leftBarButtonFont = UIFont(name: "OTSBAggroL", size: 17)
            
            let newCapturePhotoImage = config.icons.captureVideoImage
            config.icons.capturePhotoImage = newCapturePhotoImage
            
            let picker = YPImagePicker(configuration: config)
            
            picker.modalPresentationStyle = .fullScreen
            picker.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OTSBAggroM", size: 17)!]
            
            
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
            
            return false
        } else {
            return true
        }
    }    
}

extension MainTabbarController: MainListViewControllerDelegate {
    func postUpdate(documentID: String, caption: String) { }
    
    func reload() {
        if let mainListVC = viewControllers?[0] as? MainListViewController {
            mainListVC.updateReload()
        }
    }
    
}
