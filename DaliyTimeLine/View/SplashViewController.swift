//
//  SplashViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import SnapKit
import Firebase

class SplashViewController: UIViewController {
    //TODO: - 로그인 체크를 해당 controller에서 해야함 -> 로그인이 안되었을때 로그인 페이지로 로그인이 되어있는 경우 메인 탭바로 이동
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "calendar")
        iv.tintColor = .black
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Daily TimeLine"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counfigureUI()
       
        //
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
          print("\(key) = \(value) \n")
        }
        
        if let _ = Auth.auth().currentUser {
            if UserDefaults.standard.string(forKey: "LoginSecret") != nil {
                let secertView = SecretSettingViewController(isLogin: true)
                secertView.modalPresentationStyle = .fullScreen
                secertView.delegate = self
                self.present(secertView, animated: true)
            } else {
                goToMain()
            }
        } else {
            let loginView = LoginViewController(viewModel: LoginViewModel())
            loginView.modalPresentationStyle = .fullScreen
            loginView.delegate = self
            self.present(loginView, animated: true)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func counfigureUI() {
        view.backgroundColor = .white
        
        [logoImageView, titleLabel].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.centerX.centerY.equalTo(self.view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.view)
        }
        
        
    }
    
}
extension SplashViewController: LoginDelegate, SecretSettingViewDelegate {
    func goToMain() {
        if let navigationController = self.navigationController {
            let viewControllerB = MainTabbarController() // YourBViewController는 B 뷰 컨트롤러의 클래스명으로 대체되어야 합니다.
            navigationController.navigationBar.isHidden = true
            navigationController.pushViewController(viewControllerB, animated: true)
        }
    }
}
