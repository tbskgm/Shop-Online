//
//  LogInRepository.swift
//  Shop OnlineTests
//
//  Created by 小駒翼 on 2021/03/15.
//

import XCTest

@testable import Shop_Online

class LogInRepositoryTests: XCTestCase {
    let logInRepository: LogInRepositoryProtocol = LogInRepository()
    
    
    func testLogInState() {
        let logInMethods = ["Apple", "Google", "none", "gest", "mailAddress"]
        
        for logInMethod in logInMethods {
            logInRepository.logInState(howToLogIn: logInMethod).subscribe(onSuccess: { result in
                switch logInMethod {
                case "none":
                    XCTAssertEqual(result, "現在ログインされていません")
                case "gest":
                    XCTAssertEqual(result, "前回は匿名でログインされました")
                case "mailAddress":
                    XCTAssertEqual(result, "前回はメールアドレスでログインされました")
                case "Apple":
                    XCTAssertEqual(result, "前回はAppleでログインされました")
                case "Google":
                    XCTAssertEqual(result, "前回はGoogleでログインされました")
                default:
                    fatalError("新たなログイン方法が追加されているので修正してください")
                }
            }, onError: { error in
                XCTFail("想定外の値の検出")
            })
            .dispose()
        }
    }
    
    func testLogInWithMailAddress() {
        let failreEmail = "shop_Online@example.com"
        let failrePassword = "かf4h0gfんkd4h3みgien5gおsp7eさn21ka3nd"
        
        logInRepository.logInWithMailAddress(email: failreEmail, password: failrePassword).subscribe(onSuccess: { result in
            XCTFail("このアカウントは存在しません")
        }, onError: { error in
            print("成功")
        })
        .dispose()
        
        let successEmail = "yxiaoju01@gmail.com"
        let successPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        logInRepository.logInWithMailAddress(email: successEmail, password: successPassword).subscribe(onSuccess: { result in
            print("成功")
        }, onError: { error in
            XCTFail("ログイン処理に誤りがあります: \(error.localizedDescription)")
        })
        .dispose()
    }
    
    func xtestSignInWithMailAddress() {
        // すでにログインしているアカウントからはエラーが起きるようにテストする
        //
    }
    
    func xtestReSendEmail() {
        
    }
    
    func testSendAuthenticationLinkEmail() {
        let registeredEmail = "yxiaoju01@gmail.com"
        
        logInRepository.sendLinkEmail(email: registeredEmail).subscribe(onSuccess: { result in
            XCTFail("このメールアドレスはすでに登録されているはずです。")
        }, onError: { error in
            print("成功")
        })
        .dispose()
        
        let notRegistedEmail = "shop_Online@example.com"
        logInRepository.sendLinkEmail(email: notRegistedEmail).subscribe(onSuccess: { result in
            print("成功")
        }, onError: { error in
            XCTFail("失敗")
        })
        .dispose()
    }
    
    func testSignInWithAnnoynously() {
        logInRepository.signInWithAnnoymously().subscribe(onSuccess: { result in
            
        }, onError: { error in
            XCTFail("匿名ログイン失敗")
        })
        .dispose()
    }
    
    func testSignOut() {
        logInRepository.signOut().subscribe(onSuccess: { result in
            // 成功
        }, onError: { error in
            XCTFail()
        })
        .dispose()
    }
    
    
}

