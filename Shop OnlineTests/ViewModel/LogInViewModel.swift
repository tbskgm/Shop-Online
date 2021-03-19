//
//  LogInViewModel.swift
//  Shop OnlineTests
//
//  Created by 小駒翼 on 2021/03/15.
//

import XCTest

@testable import Shop_Online

class LogInViewModelTests: XCTestCase {
    let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    
    
    func testLogInState() {
        logInViewModel.logInState().subscribe(onSuccess: { result in
            if result == "nil" {
                let bool = UserDefaults.standard.string(forKey: "howToLogIn")
                XCTAssertNil(bool)
            } else {
                let bool = UserDefaults.standard.string(forKey: "howToLogIn")
                XCTAssertNotNil(bool)
            }
        }, onError: { error in
            XCTFail()
        })
        .dispose()
    }
    
    func testLogInWithMailAddress() {
        let registeredEmail = "yxiaoju01@gmail.com"
        let registeredPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        logInViewModel.logInWithMailAddress(email: registeredEmail, password: registeredPassword).subscribe(onSuccess: { result in
            if result != true {
                XCTFail()
            }
        }, onError: { error in
            XCTFail("error : \(error.localizedDescription)")
        })
        .dispose()
        
        let notRegisteredEmail = "Shop_Online@example.com"
        let notRegisteredPassword = "i1gff3haq2ka7gl0vgin4igjymc8v4n6gao9lhndf6hrcu"
        logInViewModel.logInWithMailAddress(email: notRegisteredEmail, password: notRegisteredPassword).subscribe(onSuccess: { result in
            XCTFail()
        }, onError: { error in
            print("error: \(error.localizedDescription)")
        })
        .dispose()
    }
    
    
    /// メールアドレスでログインするテスト
    func testSignInWithMailAddressのテスト() {
        /// アカウントとパスワードの設定
        let developEmail = "yxiaoju01@gmail.com"
        let developPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        
        /// 結果を取得
        let developResult = logInViewModel.signInWithMailAddress(email: developEmail, password: developPassword)
        let developResultCase = developResult.case
        
        /// 結果の判別
        switch developResultCase {
        case .isRegistered:
            break // 成功
        case .error:
            XCTFail("\(developResult.value)")
        case .sendEmail:
            XCTFail("すでに登録されているはずです。")
        }
        
        /// 偽のメールアドレスとパスワードを設定
        let fakeEmail = "Shop_Online@example.com"
        let fakePassword = "fdexiohdov2f37lp5nfortr4d0psc9hfefhssn83s74gks9nhcw53"
        
        /// 結果の取得
        let fakeResult = logInViewModel.signInWithMailAddress(email: fakeEmail, password: fakePassword)
        let fakeResultCase = fakeResult.case
        
        /// 結果の判定
        switch fakeResultCase {
        case .isRegistered:
            XCTFail("存在しないアカウントです")
        case .error:
            XCTFail("\(fakeResult.value)")
        case .sendEmail:
            break // 成功
        }
    }
    
    func testReSendEmail() {
        let fakeEmail = "Shop_Online@example.com"
        let fakeExpectation = self.expectation(description: "fakeReSendEmail")
        logInViewModel.reSendEmail(email: fakeEmail).subscribe(onSuccess: { result in
            fakeExpectation.fulfill()
        }, onError: { error in
            XCTFail("\(error.localizedDescription)")
        })
        .dispose()
        wait(for: [fakeExpectation], timeout: 5)
        
        let developEmail = "yxiaoju01@gmail.com"
        let developExpectation = self.expectation(description: "developReSendEmail")
        logInViewModel.reSendEmail(email: developEmail).subscribe(onSuccess: { result in
            XCTFail()
        }, onError: { error in
            developExpectation.fulfill()
        })
        .dispose()
        wait(for: [developExpectation], timeout: 5)
    }
    
    func testSignInWithAnnoymously() {
        logInViewModel.signInWithAnnoymously().subscribe(onSuccess: { result in
            // 成功
        }, onError: { error in
            print("error: \(error.localizedDescription)")
            XCTFail()
        })
        .dispose()
    }
    
    func testSignOut() {
        logInViewModel.signOut().subscribe(onError: { _ in
            XCTFail()
        })
        .dispose()
    }
}
