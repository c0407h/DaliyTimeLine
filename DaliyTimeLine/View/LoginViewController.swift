//
//  LoginViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import SnapKit
import AuthenticationServices
import GoogleSignIn
import Firebase
import FirebaseAuth

protocol LoginDelegate {
    func goToMain()
}

fileprivate var currentNonce: String?

class LoginViewController: UIViewController {
    
    private var viewModel: LoginViewModel
    
    var delegate: LoginDelegate?
    
    
    
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
        label.textColor = .black
        label.text = "Daily TimeLine"
        label.textAlignment = .center
        return label
    }()
    
//    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
//        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
//        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//        return button
//    }()
//    
//    private lazy var googleLoginButton: GIDSignInButton = {
//        let button = GIDSignInButton()
//        button.style = .wide
//        button.addTarget(self, action: #selector(handleAuthorizationGoogleButtonPress), for: .touchUpInside)
//        return button
//    }()
    
    
    private lazy var googleLoginButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Google로 로그인", for: .normal)
        button.setImage(UIImage(named: "google_Logo"), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(handleAuthorizationGoogleButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage(named: "apple_Logo"), for: .normal)
        button.setTitle("Apple로 로그인", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    required init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counfigureUI()
    }
    
    func counfigureUI() {
        view.backgroundColor = .white
        
        [logoImageView, titleLabel].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
//            make.top.equalToSuperview().offset(150)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.view)
        }
        
//        sampleButton.snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
//        
//        sampleGoogleLoginButton.snp.makeConstraints { make in
//            make.height.equalTo(50)
//        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        let stack = UIStackView(arrangedSubviews: [appleLoginButton, googleLoginButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaInsets.bottom).offset(-150)
            make.centerX.equalTo(self.view)
            make.leading.equalTo(self.view).offset(50)
            make.trailing.equalTo(self.view).offset(-50)
        }
    }
    
    //Apple Login Action
    @objc func handleAuthorizationAppleIDButtonPress() {
        startSignInWithAppleFlow()
    }
    
    //Google Login Action
    @objc func handleAuthorizationGoogleButtonPress() {
        startSignInWithGoogle()
    }
    
    
    func moveMain() {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.goToMain()
        }
    }
}





extension LoginViewController {
    func startSignInWithAppleFlow() {
        let nonce = viewModel.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = viewModel.sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func startSignInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            
            Auth.auth().signIn(with: credential) { result, error in
                guard let user = result?.user else { return }
                let data: [String: Any] = ["email": user.email as Any,
                                           "fullname": user.displayName as Any,
                                           "uid": user.uid,
                                           "username": user.displayName as Any]
                print("data", data)
                COLLECTION_USERS.document(user.uid).setData(data)
                
                
                self.moveMain()

            }
        }
    }
    
}




// ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let codeString = String(data: authorizationCode, encoding: .utf8) {
                print(codeString)
            }

            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            // Sign in with Firebase.
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                
                
                
                guard let user = authResult?.user else { return }
                
                let data: [String: Any] = ["email": user.email as Any,
                                           "fullname": user.displayName as Any,
                                           "uid": user.uid,
                                           "username": user.displayName as Any]
                
                COLLECTION_USERS.document(user.uid).setData(data)
                //로그인이 되었다면..
//                if let auth = authResult {
//                    self.createUser()
//                }
                
                // User is signed in to Firebase with Apple.
                // ...
                
                self.moveMain()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
}


