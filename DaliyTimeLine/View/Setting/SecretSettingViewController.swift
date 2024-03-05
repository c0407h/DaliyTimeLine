//
//  SecretSettingViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 3/5/24.
//

import UIKit

protocol SecretSettingViewDelegate: AnyObject {
    func settingSecretCancel()
}

class SecretSettingViewController: UIViewController {
    weak var delegate: SecretSettingViewDelegate?
    
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
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
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
        passCodeFirstView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        passCodeSecondView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        passCodeThirdView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        passCodeFouthView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        
        self.view.addSubview(allCodeStackView)
        allCodeStackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(self.view)
            $0.trailing.lessThanOrEqualTo(self.view)
            $0.centerX.equalTo(self.view)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
        
        [firstStackView, secondStackView, thirdStackView, fourthStackView].forEach {
            allCodeStackView.addArrangedSubview($0)
        }
    
        [numberOneButton, numberTwoButton, numberThreeButton].forEach {
            firstStackView.addArrangedSubview($0)
        }
        numberOneButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberTwoButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberThreeButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        
        [numberFourButton, numberFiveButton, numberSixButton].forEach {
            secondStackView.addArrangedSubview($0)
        }
        
        numberFourButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberFiveButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberSixButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        
        [numberSevenButton, numberEightButton, numberNineButton].forEach {
            thirdStackView.addArrangedSubview($0)
        }
        numberSevenButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberEightButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberNineButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        
        [numberBackButton, numberZeroButton, numberDeleteButton].forEach {
            fourthStackView.addArrangedSubview($0)
        }
        numberBackButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberZeroButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        numberDeleteButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.width.equalTo(80)
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
                print("second", text , secondPassCode)
                secondSecretCheck()
            } else {
                passCode += text
                print("first", text , passCode)
                secretCheck()
            }
            
        }
    }
    
    @objc func delteButtonTapped() {
        if isFirstPassCode {
            secondPassCode = String(secondPassCode.dropLast())
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
            passCodeFirstView.backgroundColor = .white
            passCodeSecondView.backgroundColor = .white
            passCodeThirdView.backgroundColor = .white
            passCodeFouthView.backgroundColor = .white
            subTitleLabel.text = "확인을 위해 한번 더 입력해주세요."
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
        
        if secondPassCode.count == 4 && isSecondPassCode {
            if secondPassCode == passCode {
//                UserService.createUserPassCode(passcode: secondPassCode)
                self.dismiss(animated: true)
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


import SwiftUI
struct HomeViewControllerPreViews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let homeVC = SecretSettingViewController()
            return homeVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
        
        typealias UIViewControllerType = UIViewController
    }
}

