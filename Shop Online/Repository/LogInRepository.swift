//
//  LoginRepository.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/22.
//

import RxSwift
import FirebaseAuth

/// ログイン方法の識別
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

/// エラーの識別
enum LogInError: LocalizedError, Error {
    case thePasswordIsInvalidOrTheUserDoesNotHaveAPassword
    
    var errorDescription: String? {
        switch self {
        case .thePasswordIsInvalidOrTheUserDoesNotHaveAPassword:
            return "パスワードが無効であるか、ユーザーがパスワードを持っていない場合があります"
        //case .unknown: return "unknown error happened"
        }
    }
    
}

/// LogInRepositoryのプロトコル
protocol LogInRepositoryProtocol {
    func logInState(howToLogIn: String) -> Single<String>
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func signInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func sendLinkEmail(email: String) -> Single<Bool>
    
    func signInWithAnnoymously() -> Single<Bool>
    
    func signOut() -> Single<Bool>
}
/// ログインに関するRepository
class LogInRepository: LogInRepositoryProtocol {
    /// ログイン状態を返す関数
    func logInState(howToLogIn: String) -> Single<String> {
        return Single<String>.create { single -> Disposable in
            /// ログイン状況を確認してlabelにこのテキストを書く
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
    
    
    /// メールアドレスでログイン
    func logInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard let _ = authResult, error == nil else {
                    return single(.error(error!))
                }
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    
    
    /// メールアドレスでサインイン
    func signInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            /// ユーザーの作成
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let authResult = authResult, error == nil else {
                    single(.error(error!))
                    return
                }
                
                authResult.user.sendEmailVerification { error in
                    guard error == nil else {
                        single(.error(error!))
                        return
                    }
                    single(.success(true))
                    /*
                    /// メールリンク送信
                    self.sendLinkEmail(email: email).subscribe(onSuccess: { result in
                        single(.success(true))
                    }, onError: { error in
                        single(.error(error))
                     })
                     .dispose()
                    */
                }
            }
            return Disposables.create()
        }
    }
    
    
    /// メールリンクを送信する
    func sendLinkEmail(email: String) -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://Shop_Online.com/createAccount")
            /// サインイン操作はアプリ内で常に完了している必要があります。
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            actionCodeSettings.setAndroidPackageName("com.example.android",
                                                     installIfNotAvailable: false, minimumVersion: "12")
            
            Auth.auth().sendSignInLink(toEmail:email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    single(.error(error))
                    return
                }
                
                UserDefaults.standard.set(email, forKey: "Email")
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    
    
    /// 匿名でログインする関数
    func signInWithAnnoymously() -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            Auth.auth().signInAnonymously { authResult, error in
                guard let _ = authResult?.user, error == nil else {
                    return single(.error(error!))
                }
                single(.success(true))
            }
            return Disposables.create()
        }
    }
    
    
    /// サインアウトする関数
    func signOut() -> Single<Bool> {
        return Single<Bool>.create { single -> Disposable in
            do {
                let firebaseAuth = Auth.auth()
                try firebaseAuth.signOut()
                single(.success(true))
            } catch let signOutError as NSError {
                single(.error(signOutError))
            }
            return Disposables.create()
        }
    }
    
    
    
    
    
    
}
