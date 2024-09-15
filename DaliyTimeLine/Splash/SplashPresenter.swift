//
//  SplashPresenter.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidLoad()
    func navigateToLogin()
    func navigateToMainTab()
    func navigateToSecretSetting()
}

class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    var interactor: SplashInteractorProtocol?
    var router: SplashRouterProtocol?

    func viewDidLoad() {
        interactor?.checkLoginStatus()
    }

    func navigateToLogin() {
        router?.navigateToLogin()
    }

    func navigateToMainTab() {
        router?.navigateToMainTab()
    }

    func navigateToSecretSetting() {
        router?.navigateToSecretSetting()
    }
}
