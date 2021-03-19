//
//  LogInViewModel.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/24.
//

import RxSwift



protocol LogInViewModelProtocol {
    func logInState() -> Single<String>
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func signInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func sendLinkEmail(email: String) -> Single<Bool>
    
    func signInWithAnnoymously() -> Single<Bool>
    
    func signOut() -> Single<Bool>
}
/// ログインのViewModel
class LogInViewModel: LogInViewModelProtocol {
    let logInRepository: LogInRepositoryProtocol = LogInRepository()
    let userDefaultsPresenter: UserDefaultsPresentation = UserDefaultsPresenter()
    let forKey = "howToLogIn"
    
    /// ログイン状態を取得
    func logInState() -> Single<String> {
        guard let howToLogIn = userDefaultsPresenter.string(forKey: forKey) else {
            return Single<String>.create { single -> Disposable in
                single(.success("nil"))
                return Disposables.create()
            }
        }
        return logInRepository.logInState(howToLogIn: howToLogIn)
    }
    
    /// メールアドレスでログイン
    func logInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return logInRepository.logInWithMailAddress(email: email, password: password).map { bool -> Bool in
            if bool == true {
                self.userDefaultsPresenter.set("mailAddress", forKey: self.forKey)
            }
            return bool
        }
    }
    
    /// メールアドレスでサインイン
    func signInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return logInRepository.signInWithMailAddress(email: email, password: password)
    }
    
    /// メールリンクを送信する関数
    func sendLinkEmail(email: String) -> Single<Bool> {
        return logInRepository.sendLinkEmail(email: email)
    }
    
    /// 匿名でログインする関数
    func signInWithAnnoymously() -> Single<Bool> {
        logInRepository.signInWithAnnoymously().map { bool -> Bool in
            if bool == true {
                self.userDefaultsPresenter.set("gest", forKey: self.forKey)
            }
            return bool
        }
    }
    
    /// サインアウトする関数
    func signOut() -> Single<Bool> {
        logInRepository.signOut().map{ bool -> Bool in
            self.userDefaultsPresenter.set("none", forKey: self.forKey)
            return bool
        }
    }
    
}

