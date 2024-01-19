//
//  MainTabbarController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
        configureUI()
    }
    
    func configureTabbar() {
        let mainListController = MainListViewController()
        mainListController.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName:  "calendar"), selectedImage: nil)
               
        let profileController = ProfileViewController()
        profileController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "calendar"), selectedImage: nil)
        
        
        viewControllers = [mainListController, profileController]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        self.delegate = self
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
}


extension MainTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            
            return false
        }
        return true
    }
}
