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
    
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String)
    
    func reSendEmail(email: String) -> Single<Bool>
    
    func signInWithAnnoymously() -> Single<Bool>
    
    func signOut() -> Single<Bool>
}
class LogInViewModel: LogInViewModelProtocol {
    let logInRepository: LogInRepositoryProtocol = LogInRepository()
    let userDefaults = UserDefaults.standard
    let forKey = "howToLogIn"
    
    func logInState() -> Single<String> {
        guard let howToLogIn = self.userDefaults.string(forKey: forKey) else {
            return Single<String>.create { single -> Disposable in
                single(.success("nil"))
                return Disposables.create()
            }
        }
        return logInRepository.logInState(howToLogIn: howToLogIn)
    }
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return logInRepository.logInWithMailAddress(email: email, password: password).map { bool -> Bool in
            if bool == true {
                self.userDefaults.set("mailAddress", forKey: self.forKey)
            }
            return bool
        }
    }
    
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String) {
        let result = logInRepository.signInWithMailAddress(email: email, password: password)
        let resultCase = result.case
        if resultCase == .sendEmail {
            userDefaults.set(true, forKey: "isSendEmail")
        }
        return result
    }
    
    func reSendEmail(email: String) -> Single<Bool> {
        return logInRepository.reSendEmail(email: email)
    }
    
    func signInWithAnnoymously() -> Single<Bool> {
        logInRepository.signInWithAnnoymously().map { bool -> Bool in
            if bool == true {
                self.userDefaults.set("gest", forKey: self.forKey)
            }
            return bool
        }
    }
    
    func signOut() -> Single<Bool> {
        logInRepository.signOut().map{ bool -> Bool in
            self.userDefaults.set("none", forKey: self.forKey)
            return bool
        }
    }
    
}

