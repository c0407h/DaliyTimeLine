//
//  MainTabbarController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import Firebase
import FirebaseAuth

protocol MainTabbarViewProtocol: AnyObject {
    func configureTabbar()
    func reloadMainListView()
}


class MainTabbarController: UITabBarController, MainTabbarViewProtocol {
    var presenter: MainTabbarPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func configureTabbar() {
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
        if safeAreaBottomInset() != 0 {
            haveSAtabbarSetup()
        } else {
            noHaveSAtabbarSetup()
        }
    }
    
    func haveSAtabbarSetup() {
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
    
    func noHaveSAtabbarSetup() {
        self.tabBar.frame.size.height = 49
        self.tabBar.frame.origin.y = self.view.frame.height - 49
        self.tabBar.frame.origin.x = 0
        self.tabBar.frame.size.width = tabBar.bounds.width
        
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.borderWidth = 1
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.layer.cornerRadius = 24
        self.tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
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
    
    func reloadMainListView() {
        if let mainListVC = viewControllers?[0] as? MainListViewController {
            mainListVC.updateReload()
        }
    }
}


extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is UploadContentViewController {
            presenter?.didSelectUpload()
            return false
        } else {
            return true
        }
    }
    
    func safeAreaBottomInset() -> CGFloat {
        if let window = view.window {
            return window.safeAreaInsets.bottom
        }
        return 0.0
    }
}
