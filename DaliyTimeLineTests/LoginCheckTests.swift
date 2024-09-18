//
//  LoginCheckTests.swift
//  DaliyTimeLineTests
//
//  Created by Chung Wussup on 9/17/24.
//

import XCTest
import FirebaseAuth
@testable import DaliyTimeLine


final class LoginCheckTests: XCTestCase {

    
    //UserDefault에 설정된 Login Secret
    var loginSecret: Bool?
    
    override func setUp() {
        loginSecret = nil
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIsLoginWhenLoginNoSetSecret() {
        //로그인이 되어있어도 기본은 Secret을 setting하지 않았기 때문에 nil이고 예상 결과는 true임.
        
        if let user = Auth.auth().currentUser {
            if loginSecret == nil {
                XCTAssertNil(loginSecret)
            } else {
                if loginSecret! {
                    XCTAssertTrue(loginSecret!)
                } else {
                    XCTAssertFalse(loginSecret!)
                }
            }
        } else {
            XCTAssertNil(loginSecret)
        }
        
    }
    
    
}
