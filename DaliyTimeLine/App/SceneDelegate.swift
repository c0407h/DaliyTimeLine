//
//  SceneDelegate.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var rootRouter: RootWireframe?
    
    
    func goToSplashScreen() {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = UINavigationController(rootViewController: SplashViewController())
//        self.window = window
//        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        rootRouter = RootRouter()
        rootRouter?.setRootViewControllerToSplash(in: window)
    }
    
    func goToMain() {
        guard let window = self.window else { return }
        
        rootRouter?.setRootViewControllerToMain(in: window)
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

