//
//  SplashInteractor.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 9/15/24.
//

import FirebaseAuth

protocol SplashInteractorProtocol: AnyObject {
    func checkLoginStatus()
}

class SplashInteractor: SplashInteractorProtocol {
    weak var presenter: SplashPresenterProtocol?

    func checkLoginStatus() {
        // Firebase 인증을 통해 로그인 상태 확인
        if let _ = Auth.auth().currentUser {
            // 로그인 되어 있음, Secret 설정 확인
            if UserDefaults.standard.string(forKey: "LoginSecret") != nil {
                presenter?.navigateToSecretSetting()
            } else {
                presenter?.navigateToMainTab()
            }
        } else {
            // 로그인 안 되어 있음
            presenter?.navigateToLogin()
        }
    }
}
