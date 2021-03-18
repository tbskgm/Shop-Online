//
//  LoginViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/21.
//

import UIKit
/// 認証関係
import GoogleSignIn
import FirebaseAuth
import FirebaseUI

import FirebaseDatabase
import Firebase
import FirebaseCrashlytics
import RxSwift

class LogInViewController: UIViewController, FUIAuthDelegate {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordSwitch: UISwitch!
    @IBOutlet weak var showLogInStateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    let userDefaultsPresenter: UserDefaultsPresentation = UserDefaultsPresenter()
    let forKey = "howToLogIn"
    
    lazy var logInRouter: LogInRouterProtocol = LogInRouter(vc: self)
    
    let disposeBag = DisposeBag()
    
    var authHandle: AuthStateDidChangeListenerHandle?
    var firstTimeSetup = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        /// ログイン状況を確認してlabelにこのテキストを書く
        logInViewModel.logInState().subscribe(onSuccess: { result in
            if result == "nil" {
                self.showLogInStateLabel.text = "ログインされたことがないので新規登録をお願い致します。"
            } else {
                self.showLogInStateLabel.text = result
            }
        }, onError: { error in
            let alert = self.alertViewModel.showAlert(title: "", message: "\(error.localizedDescription)")
            self.present(alert, animated: true)
        })
        .disposed(by: disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil, firstTimeSetup == true {
            logInRouter.segue(withIdentifier: .SearchViewController)
        }
        
        /// ユーザーのログイン状態が変更される度に呼び出され、変更される度に実行したい処理をここに書きます。
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            /// ログイン状態が変更された時の処理を書く
        })
        firstTimeSetup = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    
    /// labelのアラートを出す
    func labelAlert(text: String) {
        messageLabel.isHidden = false
        messageLabel.text = text
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + 2) {
            self.messageLabel.isHidden = true
        }
    }
    
    
    /// キーボードを閉じる
    func closeKeyboard() {
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    
    /// パスワードを表示する
    @IBAction func showpasswordSwitch(_ sender: Any) {
        let isOn = showPasswordSwitch.isOn
        switch isOn {
        case true:
            passwordTextField.isSecureTextEntry = false
            showPasswordSwitch.isOn = true
        case false:
            passwordTextField.isSecureTextEntry = true
            showPasswordSwitch.isOn = false
        }
    }
    
    
    /// パスワードを忘れた時の処理
    @IBAction func forgetPasswordButton(_ sender: Any) {
        closeKeyboard()
        logInRouter.segue(withIdentifier: .ForgetPasswordViewController)
    }
    
    
    /// メールアドレスでログイン
    @IBAction func loginWithMailAddressButton(_ sender: Any)  {
        closeKeyboard()
        /// textFieldの確認
        guard let email = mailAddressTextField.text, mailAddressTextField.text != "" else {
            return labelAlert(text: "メールアドレスを登録してください")
        }
        guard let password = passwordTextField.text, passwordTextField.text != "" else {
            return labelAlert(text: "パスワードを登録してください")
        }
        
        /// ログイン処理
        logInViewModel.logInWithMailAddress(email: email, password: password).subscribe(onSuccess: { result in
            self.logInRouter.segue(withIdentifier: .SearchViewController)
        }, onError: { error in
            let alert = self.alertViewModel.showAlert(title: "", message: "\(error.localizedDescription)")
            self.present(alert, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
    
    
    /// 新規登録
    @IBAction func signInWithMailAddressButton(_ sender: Any) {
        closeKeyboard()
        /// 画面遷移
        logInRouter.segue(withIdentifier: .SignInWithMailAddressViewController)
    }
    
    
    /// Appleでサインイン
    @IBAction func signInWithAppleButton(_ sender: Any) {
        closeKeyboard()
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let _ = authDataResult?.user {
            userDefaultsPresenter.set("Apple", forKey: forKey)
        }
    }
    
    /// 匿名でサインイン
    @IBAction func signInWithAnnoymouslyButton(_ sender: Any) {
        closeKeyboard()
        logInViewModel.signInWithAnnoymously().subscribe(onSuccess: { result in
            if result == true {
                self.logInRouter.segue(withIdentifier: .SearchViewController)
            }
        }, onError: { error in
            self.labelAlert(text: "匿名のサインインに失敗しました: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    /// サインアウトボタン
    @IBAction func signOutButton(_ sender: Any) {
        closeKeyboard()
        logInViewModel.signOut().subscribe(onSuccess: { result in
            self.labelAlert(text: "サインアウトしました")
        }, onError: { error in
            self.labelAlert(text: "サインアウトに失敗しました: \(error)")
        })
        .disposed(by: disposeBag)
    }
}


extension LogInViewController: UITextFieldDelegate {
    /// returnキーをタップしてキーボードを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /// textField以外をタップするとキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
