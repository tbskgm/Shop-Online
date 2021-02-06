//
//  LoginRepository.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/22.
//

import RxSwift
import FirebaseAuth


enum HowToLogIn {
    case none
    case gest
    case mailAddress
    case Apple
    case Google
    
    init(stringHowToLoginCese: String) {
        switch stringHowToLoginCese {
        case "none":
            self = .none
        case "gest":
            self = .gest
        case "mailAddress":
            self = .mailAddress
        case "Apple":
            self = .Apple
        case "Google":
            self = .Google
        default:
            // https://firebase.google.com/docs/crashlytics/customize-crash-reports#log-excepts
            fatalError()
        }
    }
}


enum SignInWithMailAddressState: String {
    case isRegistered
    case sendEmail
    case error
}


enum LogInError {
    case thePasswordIsInvalidOrTheUserDoesNotHaveAPassword
    
    init(error: String) {
        switch error {
        case "The password is invalid or the user does not have a password.":
            self = .thePasswordIsInvalidOrTheUserDoesNotHaveAPassword
        default:
            fatalError("想定外のエラーの検出")
        }
    }
}


protocol LogInRepositoryProtocol {
    func logInState(howToLogIn: String) -> Single<String>
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String)
    
    func reSendEmail(email: String) -> Single<Bool>
    
    func sendAuthenticationLinkEmail(email: String) -> Single<Bool>
    
    func signInWithAnnoymously() -> Single<Bool>
    
    func signOut() -> Single<Bool>
}



class LogInRepository: LogInRepositoryProtocol {
    
    func logInState(howToLogIn: String) -> Single<String> {
        return Single<String>.create { single -> Disposable in
            // ログイン状況を確認してlabelにこのテキストを書く
            switch HowToLogIn(stringHowToLoginCese: howToLogIn) {
            case HowToLogIn.none:
                single(.success("現在ログインされていません"))
            case HowToLogIn.Apple:
                single(.success("前回はAppleでログインされました"))
            case HowToLogIn.Google:
                single(.success("前回はGoogleでログインされました"))
            case HowToLogIn.mailAddress:
                single(.success("前回はメールアドレスでログインされました"))
            case HowToLogIn.gest:
                single(.success("前回は匿名でログインされました"))
            }
            return Disposables.create()
        }
    }
    
    
    // メールアドレスでログイン
    func logInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard let authResult = authResult, error == nil else {
                    print("サインインに失敗しました:" ,error!.localizedDescription)
                    return single(.error(error!))
                }
                let user = authResult.user
                print("サインインに成功しました", user.email!)
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    /*
    func exmapleMailAddressLogIn() {
        Auth.auth().signIn(withEmail: mail, password: password) { (result, error) in
            if error == nil, let result = result, result.user.isEmailVerified {
                self.performSegue(withIdentifier: "toMainView", sender: result.user)
            } else if error != nil {
                let alert = UIAlertController(title: "ログインエラー", message: "パスワードまたはメールアドレスが違います。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }*/
    
    
    // メールアドレスでサインイン
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String) {
        var returnValue = "isRegistered"
        var returnCase = SignInWithMailAddressState.isRegistered
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let authResult = authResult, error == nil else {
                returnValue = error!.localizedDescription
                returnCase = .error
                return
            }
            
            authResult.user.sendEmailVerification { error in
                guard error == nil else {
                    returnValue = error!.localizedDescription
                    returnCase = .error
                    return
                }
                returnValue = "sendEmail"
                returnCase = .sendEmail
                self.sendAuthenticationLinkEmail(email: email)
            }
        }
        return (returnCase, returnValue)
    }
    /*func signInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let authResult = authResult, error == nil else {
                    return single(.error(error!))
                }
                
                authResult.user.sendEmailVerification { (error) in
                    guard error == nil else {
                        return single(.error(error!))
                    }
                    single(.success(true))
                    self.sendAuthenticationLinkEmail(email: email)
                }
            }
            return Disposables.create()
        }
    }*/
    
    
    // 認証メールを再送信
    func reSendEmail(email: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            self.sendAuthenticationLinkEmail(email: email).subscribe(
                onSuccess: { result in
                    single(.success(result))
                }, onError: { error in
                    single(.error(error))
                })
            return Disposables.create()
        }
    }
    /*func reSendEmail(email: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            self.sendAuthenticationLinkEmail(email: email).subscribe(onSuccess: {
                result in
                single(.success(true))
            }, onError: {
                error in
                single(.error(error))
            })
            return Disposables.create()
        }
    }*/
    
    // 確認メールを送る
    func sendAuthenticationLinkEmail(email: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://Shop_Online.com/createAccount")
            // サインイン操作はアプリ内で常に完了している必要があります。
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            actionCodeSettings.setAndroidPackageName("com.example.android",
                                                     installIfNotAvailable: false, minimumVersion: "12")
            
            Auth.auth().sendSignInLink(toEmail:email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    single(.error(error))
                    return
                }
                // リンクが正常に送信されました。ユーザーに通知します。メールをローカルに保存しておくことで、ユーザーに再度メールを要求する必要がなくなります。同じデバイスでリンクを開いている場合。
                UserDefaults.standard.set(email, forKey: "Email")
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    
    
    func signInWithAnnoymously() -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            Auth.auth().signInAnonymously { authResult, error in
                guard let user = authResult?.user, error == nil else {
                    //print("匿名サインインに失敗しました: \(String(describing: error!.localizedDescription))")
                    return single(.error(error!))
                }
                //print("匿名サインインに成功しました", user.uid)
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    
    func signOut() -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                //print("アインアウト成功")
                single(.success(true))
            } catch let signOutError as NSError {
                //print ("サインアウトに失敗しました: %@", signOutError)
                single(.error(signOutError))
            }
            return Disposables.create()
        }
    }
    
    
    
    
    
    
}
