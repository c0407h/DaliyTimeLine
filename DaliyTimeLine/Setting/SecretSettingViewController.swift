//
//  SecretSettingViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/5/24.
//

import UIKit
import LocalAuthentication

protocol SecretSettingViewDelegate: AnyObject {
    func settingSecretCancel()
    func goToMain()
}
extension SecretSettingViewDelegate {
    func settingSecretCancel() {}
    func goToMain() {}
}

class SecretSettingViewController: UIViewController {
    weak var delegate: SecretSettingViewDelegate?
    
    var isLogin: Bool
    let authContext = LAContext()
    
    init(isLogin: Bool = false) {
        self.isLogin = isLogin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "암호 입력"
        label.textAlignment = .center
        label.font = UIFont(name: "OTSBAggroM", size: 18)
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "네자리 숫자를 입력해주세요."
        label.textAlignment = .center
        label.font = UIFont(name: "OTSBAggroM", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    var allCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    var firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var thirdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var fourthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var numberOneButton: UIButton = {
        let button = UIButton()
        button.setTitle("1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberTwoButton: UIButton = {
        let button = UIButton()
        button.setTitle("2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberThreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("3", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberFourButton: UIButton = {
        let button = UIButton()
        button.setTitle("4", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberFiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("5", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberSixButton: UIButton = {
        let button = UIButton()
        button.setTitle("6", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberSevenButton: UIButton = {
        let button = UIButton()
        button.setTitle("7", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberEightButton: UIButton = {
        let button = UIButton()
        button.setTitle("8", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberNineButton: UIButton = {
        let button = UIButton()
        button.setTitle("9", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberZeroButton: UIButton = {
        let button = UIButton()
        button.setTitle("0", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var numberBackButton: UIButton = {
        let button = UIButton()
        if !isLogin {
            button.setTitle("취소", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
        }
        return button
    }()
    
    lazy var numberDeleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(delteButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    var sceretPasscordView: UIView = {
        let view = UIView()
        return view
    }()
    
    var passCordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var passCodeFirstView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    var passCodeSecondView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    var passCodeThirdView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    var passCodeFouthView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        
        if isLogin {
            if UserDefaults.standard.string(forKey: "LoginSecret") != nil {
                authContext.localizedFallbackTitle = ""
                
                self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "잠금을 위해 인증을 해주세요.") { success, error in
                    if success {
                        DispatchQueue.main.async {
                            self.delegate?.goToMain()
                            self.dismiss(animated: true)
                        }
                        
                    } else {
                    }
                }
            }
        }
    }
    
    private func configureUI() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(150)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(sceretPasscordView)
        sceretPasscordView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(self.view)
            $0.leading.greaterThanOrEqualTo(self.view)
            $0.trailing.lessThanOrEqualTo(self.view)
        }
        
        sceretPasscordView.addSubview(passCordStackView)
        passCordStackView.snp.makeConstraints {
            $0.centerX.equalTo(sceretPasscordView)
            $0.edges.equalTo(sceretPasscordView)
        }
        
        [passCodeFirstView, passCodeSecondView, passCodeThirdView,passCodeFouthView].forEach {
            passCordStackView.addArrangedSubview($0)
        }
        
        [passCodeFirstView, passCodeSecondView, passCodeThirdView,passCodeFouthView].forEach {
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
        }
        
        
        self.view.addSubview(allCodeStackView)
        allCodeStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(self.view)
            $0.trailing.lessThanOrEqualTo(self.view)
            $0.top.greaterThanOrEqualTo(passCordStackView)
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-80)
        }
        
        [firstStackView, secondStackView, thirdStackView, fourthStackView].forEach {
            allCodeStackView.addArrangedSubview($0)
        }
        
        [numberOneButton, numberTwoButton, numberThreeButton].forEach {
            firstStackView.addArrangedSubview($0)
        }
        [numberOneButton, numberTwoButton, numberThreeButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(80)
            }
        }
        
        
        [numberFourButton, numberFiveButton, numberSixButton].forEach {
            secondStackView.addArrangedSubview($0)
        }
        
        [numberFourButton, numberFiveButton, numberSixButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(80)
            }
        }
        
        [numberSevenButton, numberEightButton, numberNineButton].forEach {
            thirdStackView.addArrangedSubview($0)
        }
        
        [numberSevenButton, numberEightButton, numberNineButton].forEach{
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(80)
            }
        }
        
        [numberBackButton, numberZeroButton, numberDeleteButton].forEach {
            fourthStackView.addArrangedSubview($0)
        }
        [numberBackButton, numberZeroButton, numberDeleteButton].forEach{
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
                make.width.equalTo(80)
            }
        }
    }
    
    
    var passCode: String = ""
    var secondPassCode: String = ""
    
    var isFirstPassCode: Bool {
        return passCode.count == 4
    }
    var isSecondPassCode: Bool {
        return secondPassCode.count == 4
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if isFirstPassCode {
                secondPassCode += text
                secondSecretCheck()
            } else {
                passCode += text
                secretCheck()
            }
        }
    }
    
    @objc func delteButtonTapped() {
        if isFirstPassCode {
            secondPassCode = String(secondPassCode.dropLast())
            secondSecretCheck()
        } else {
            passCode = String(passCode.dropLast())
            secretCheck()
        }
    }
    
    func secretCheck() {
        
        switch self.passCode.count  {
        case 1:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .white
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        case 2:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        case 3:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .black
            passCodeFouthView.backgroundColor = .white
        case 4:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .black
            passCodeFouthView.backgroundColor = .black
        default:
            passCodeFirstView.backgroundColor = .white
            passCodeSecondView.backgroundColor = .white
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        }
        
        
        if passCode.count == 4 && isFirstPassCode{
            
            if isLogin {
                let secret: String = UserDefaults.standard.object(forKey: "LoginSecret") as! String
                
                if secret == passCode {
                    self.delegate?.goToMain()
                    self.dismiss(animated: true)
                } else {
                    passCode = ""
                    passCodeFirstView.backgroundColor = .white
                    passCodeSecondView.backgroundColor = .white
                    passCodeThirdView.backgroundColor = .white
                    passCodeFouthView.backgroundColor = .white
                    subTitleLabel.text = "암호가 일치하지 않습니다. 재입력해주세요"
                }
            } else {
                passCodeFirstView.backgroundColor = .white
                passCodeSecondView.backgroundColor = .white
                passCodeThirdView.backgroundColor = .white
                passCodeFouthView.backgroundColor = .white
                subTitleLabel.text = "확인을 위해 한번 더 입력해주세요."
            }
        }
    }
    
    func secondSecretCheck() {
        
        switch self.secondPassCode.count  {
        case 1:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .white
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        case 2:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        case 3:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .black
            passCodeFouthView.backgroundColor = .white
        case 4:
            passCodeFirstView.backgroundColor = .black
            passCodeSecondView.backgroundColor = .black
            passCodeThirdView.backgroundColor = .black
            passCodeFouthView.backgroundColor = .black
        default:
            passCodeFirstView.backgroundColor = .white
            passCodeSecondView.backgroundColor = .white
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
        }
        
        //처음입력 비밀번호와 재입력 비밀번호코드가 맞을 때
        if secondPassCode.count == 4 && isSecondPassCode {
            if secondPassCode == passCode {
                UserDefaults.standard.set(self.passCode, forKey: "LoginSecret")
                
                authContext.localizedFallbackTitle = ""
 
                self.authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "잠금을 위해 인증을 해주세요.") { success, error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            print(error.localizedDescription, error)
                            self.dismiss(animated: true)
                        }
                    }
                    
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                        
                    } else {
                    }
                    
                }
            } else {
                passCodeFirstView.backgroundColor = .white
                passCodeSecondView.backgroundColor = .white
                passCodeThirdView.backgroundColor = .white
                passCodeFouthView.backgroundColor = .white
                subTitleLabel.text = "네자리 숫자를 입력해 주세요."
                passCode = ""
                secondPassCode = ""
            }
        }
    }
    
    @objc func viewDismiss() {
        self.delegate?.settingSecretCancel()
        self.dismiss(animated: true)
    }
    
}

