//
//  SettingViewController.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 1/19/24.
//

import UIKit
import SnapKit
import FirebaseAuth



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
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(indexPath)
        case 1:
            print(indexPath)
        case 2:
            print(indexPath)
            switch indexPath.row {
            case 0:
                let sheet = UIAlertController(title: "로그 아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                
                sheet.addAction(UIAlertAction(title: "로그아웃", style: .destructive,handler: { _ in
                    
                    self.viewModel.logout {
                        print("logout")
                        print(self.navigationController?.viewControllers)
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                         sceneDelegate.goToSplashScreen()
//                        MainTabbarController().navigationController?.popToRootViewController(animated: true)
                    }
                    
                }))
                
                sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in print("yes 클릭") }))
                
                present(sheet, animated: true)
            case 1:
                print("")
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
