//
//  SettingViewModel.swift
//  DaliyTimeLine
//
//  Created by Chung Wussup on 2/9/24.
//

import Foundation
import FirebaseAuth


class SettingViewModel {
    let settingGroupTitle = ["설정", "정보", "계정", "앱 정보"]
    let settingItemTitle = [["🖼️ 사진 자동 저장","🔐 화면 잠금"],["💌 피드백","✨ 별점"],["🚶 로그아웃", "🙋🏻‍♂️ 회원탈퇴"],["📱 앱 버전"]]
    
    
    
    func logout(compltion: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            compltion()
        } catch {
            print("logout error")
        }
        
    }
    
    func deleteUser(compltion: @escaping() -> Void) {
        guard let user = Auth.auth().currentUser else {
              print("사용자가 로그인되어 있지 않습니다.")
              return
          }
        
        user.delete { error in
            if let error = error {
                print("사용자 삭제 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("사용자 삭제 성공")
                compltion()
                // 사용자 삭제 성공 시 추가적인 작업을 수행할 수 있습니다.
            }
        }

//        if let providerData = user.providerData.first {
//            switch providerData.providerID {
//            case "google.com":
//            case "apple.com":
//            default:
//                print("알 수 없음")
//            }
//        }
//          // 사용자를 회원 탈퇴시킵니다.

    }
    
    
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        print(version)
        return "v \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)"
    }
    
}
