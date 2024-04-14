//
//  SplashCoordinator.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 4/14/24.
//

import Foundation
import UIKit

protocol SplashCoordinatorDelegate {
    func goToMain(_ coordinator: Coordinator)
    
}

class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var delegate: SplashCoordinatorDelegate?
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SplashViewController()
        self.navigationController.viewControllers = [viewController]
    }
    
    
    func goToMain() {
        self.delegate?.goToMain(self)
    }

    
}
