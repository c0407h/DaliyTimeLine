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
    weak var viewController: UIViewController?

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

        return view
    }

    func navigateToLogin() {
        let loginVC = LoginViewController(viewModel: LoginViewModel())
        loginVC.modalPresentationStyle = .fullScreen
        viewController?.present(loginVC, animated: true)
    }

    func navigateToMainTab() {
        //메인 Router로 실행해야함.
        let mainTabBarVC = MainTabbarController()
        viewController?.navigationController?.pushViewController(mainTabBarVC, animated: false)
    }

    func navigateToSecretSetting() {
        let secretSettingVC = SecretSettingViewController(isLogin: true)
        secretSettingVC.modalPresentationStyle = .fullScreen
        viewController?.present(secretSettingVC, animated: true)
    }
}
