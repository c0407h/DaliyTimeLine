//
//  AppCoordinator.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 4/14/24.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
     private var navigationController: UINavigationController!
     
     var isLoggedIn: Bool = false
     
     init(navigationController: UINavigationController) {
         self.navigationController = navigationController
     }
     
     func start() {
         if self.isLoggedIn {
             self.showMainViewController()
         } else {
             self.showLoginViewController()
         }
     }
     
     private func showMainViewController() {
      
     }
     
     private func showLoginViewController() {
      
     }
}
