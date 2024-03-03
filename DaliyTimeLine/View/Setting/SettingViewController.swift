//
//  SettingViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import SnapKit
import FirebaseAuth
import StoreKit
import MessageUI


class SettingViewController: UIViewController {
    
    var viewModel = SettingViewModel()
   
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.separatorStyle = .singleLine
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkEmailAvailability()
        
    }
    
    
    private func configureUI() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.topItem?.title = "설정"
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalTo(view)
        }
    }
    
    
    private func checkEmailAvailability() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
    }
    
    private func sendEmail() {
        let composeVC = MFMailComposeViewController()
//        composeVC.delegate = self
        composeVC.mailComposeDelegate = self
        
        composeVC.setToRecipients(["rueliosdev@gmail.com"])
        composeVC.setSubject("💌피드백&문의사항")
        
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? 1.0    // 앱 버전
        let osVersion = UIDevice().systemVersion    // 기기의 os 버전
        let message = """
        피드백&문의사항을 남겨주세요.
        
        App Version: \(appVersion)
        iOS Version: \(osVersion)
        """
        
        composeVC.setMessageBody(message, isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
        
        
    }
    
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingGroupTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.settingGroupTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingItemTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.settingItemTitle[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont(name: "OTSBAggroM", size: 14)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(indexPath)
        case 1:
            switch indexPath.row {
            case 0:
                sendEmail()
            case 1:
                SKStoreReviewController.requestReviewInCurrentScene()
            default:
                print("")
            }
        case 2:
            switch indexPath.row {
            case 0:
                let sheet = UIAlertController(title: "로그 아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                
                sheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive,handler: { _ in
                    
                    self.viewModel.logout {
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                        sceneDelegate.goToSplashScreen()
                    }
                    
                }))
                
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in print("취소") }))
                
                present(sheet, animated: true)
            case 1:
                let sheet = UIAlertController(title: "회원 탈퇴", message: "탈퇴 하시겠습니까?", preferredStyle: .alert)
                
                sheet.addAction(UIAlertAction(title: "탈퇴", style: .destructive,handler: { _ in
                    
                    self.viewModel.deleteUser {
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                        sceneDelegate.goToSplashScreen()
                    }
                }))
                
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in print("취소") }))
                
                present(sheet, animated: true)
            default:
                print("")
            }
        default:
            print(indexPath)
        }
    }
}

////TODO: - 테스트 함수 - 이후 이동이나 삭제 필요
//func logoutTest() {
//    self.view.addSubview(logoutButton)
//    logoutButton.snp.makeConstraints { make in
//        make.centerX.centerY.equalTo(view)
//    }
//    logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
//}
//
//
//@objc func logout() {
//    do {
//        try Auth.auth().signOut()
//    } catch {
//        print("ASdf")
//    }
//}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}

extension SettingViewController: UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            // 메일 발송 성공 ( 인터넷이 안되는 경우도 sent처리되고, 인터넷이 연결되면 메일이 발송됨. )
            print("send")
        case .saved:
            // 메일 임시 저장
            print("save")
        case .cancelled:
            // 메일 작성 취소
            print("cancel")
        case .failed:
            // 메일 발송 실패 (오류 발생)
            print("failed")
        default:
            break
        }
        
        controller.dismiss(animated: true)
    }
    
    
    
    
}

