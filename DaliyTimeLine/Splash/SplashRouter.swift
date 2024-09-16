//
//  SplashRouter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//
import UIKit

protocol SplashRouterProtocol: AnyObject {
    func navigateToLogin()
    func navigateToMainTab()
    func navigateToSecretSetting()
}

class SplashRouter: SplashRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = SplashViewController()
        let presenter = SplashPresenter()
        let interactor = SplashInteractor()
        let router = SplashRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        print("splash view: \(view), presenter: \(presenter), interactor: \(interactor), router: \(router)")
        return view
    }

    func navigateToLogin() {
        let loginVC = LoginViewController(viewModel: LoginViewModel())
        loginVC.modalPresentationStyle = .fullScreen
        viewController?.present(loginVC, animated: true)
    }

    func navigateToMainTab() {
        //메인 Router로 실행해야함.
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToMain()
        }
        
//        if let sceneDelegate = UIApplication.shared.connectedScenes
//            .first?.delegate as? SceneDelegate {
//            print(sceneDelegate.window, "check")
//            let mainTabBarVC = MainTabbarRouter.createModule()
//            sceneDelegate.window?.rootViewController = mainTabBarVC
//            sceneDelegate.window?.makeKeyAndVisible()
//        }
        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//        let window = UIWindow(windowScene: windowScene)
//        let mainTabBarVC = MainTabbarRouter.createModule()
//        window.rootViewController = UINavigationController(rootViewController: mainTabBarVC)
//        window.makeKeyAndVisible()
    }

    func navigateToSecretSetting() {
        let secretSettingVC = SecretSettingViewController(isLogin: true)
        secretSettingVC.modalPresentationStyle = .fullScreen
        viewController?.present(secretSettingVC, animated: true)
    }
}
