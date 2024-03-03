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
}
