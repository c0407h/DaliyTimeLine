//
//  SceneDelegate.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func goToSplashScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let navigationController = UINavigationController(rootViewController: SplashViewController())
        self.window?.rootViewController = navigationController
        
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        
        let navigationController = UINavigationController(rootViewController: SplashViewController())
        self.window?.rootViewController = navigationController
        
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        
        self.window?.makeKeyAndVisible()
    }
    
    func goToMain() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let navigationController = UINavigationController(rootViewController: SplashViewController())
        self.window?.rootViewController = navigationController
        
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

