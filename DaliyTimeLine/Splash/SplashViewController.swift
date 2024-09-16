//
//  SplashViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import SnapKit
import Firebase


protocol SplashViewProtocol: AnyObject {
    func navigateToLogin()
    func navigateToMainTab()
    func navigateToSecretSetting()
}

class SplashViewController: UIViewController, SplashViewProtocol {
    var presenter: SplashPresenterProtocol?

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "logoImage.png")
        iv.tintColor = .black
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }

    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(180)
            make.center.equalToSuperview()
        }
    }

    // SplashViewProtocol 구현
    func navigateToLogin() {
        presenter?.navigateToLogin()
    }

    func navigateToMainTab() {
        presenter?.navigateToMainTab()
    }

    func navigateToSecretSetting() {
        presenter?.navigateToSecretSetting()
    }
}
//extension SplashViewController: LoginDelegate, SecretSettingViewDelegate {
//    func goToMain() {
//
//        if let navigationController = self.navigationController {
//            let viewControllerB = MainTabbarController()
//            navigationController.navigationBar.isHidden = true
//            navigationController.pushViewController(viewControllerB, animated: false)
//        }
//    }
//}
