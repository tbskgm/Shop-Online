//
//  LoginViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/21.
//

import UIKit
// 認証関係
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
    let disposeBag = DisposeBag()
    
    
    
    var authHandle: AuthStateDidChangeListenerHandle?
    let userDefaults = UserDefaults.standard
    var firstTimeSetup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // ログイン状況を確認してlabelにこのテキストを書く
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
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
        }
        
        // ユーザーのログイン状態が変更される度に呼び出され、変更される度に実行したい処理をここに書きます。
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // ログイン状態が変更された時の処理を書く
        })
        firstTimeSetup = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        Auth.auth().removeStateDidChangeListener(authHandle!)
        //print("Auth.auth().removeStateDidChangeListener(authHandle!)")
    }
    
    // textField以外をタップするとキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func transition() {
        self.performSegue(withIdentifier: "SearchViewController", sender: self)
    }
    
    // labelのアラートを出す
    func labelAlert(text: String) {
        messageLabel.isHidden = false
        messageLabel.text = text
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + 2) {
            self.messageLabel.isHidden = true
        }
    }
    
    // キーボードを閉じる
    func closeKeyboard() {
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    
    // パスワードを表示する
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
    
    
    // パスワードを忘れた時の処理
    @IBAction func forgetPasswordButton(_ sender: Any) {
        closeKeyboard()
    }
    
    
    // メールアドレスでログイン
    @IBAction func loginWithMailAddressButton(_ sender: Any)  {
        closeKeyboard()
        // textFieldの確認
        guard let email = mailAddressTextField.text, mailAddressTextField.text != "" else {
            return labelAlert(text: "メールアドレスを登録してください")
        }
        guard let password = passwordTextField.text, passwordTextField.text != "" else {
            return labelAlert(text: "パスワードを登録してください")
        }
        // 移行予定
        /*var email: String { mailAddressTextField.text! }
        var password: String { passwordTextField.text! }
        */
        
        // ログイン処理
        logInViewModel.logInWithMailAddress(email: email, password: password).subscribe(onSuccess: { result in
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
            //self.userDefaults.removeObject(forKey: "isSendEmail")
        }, onError: { error in
            let alert = self.alertViewModel.showAlert(title: "", message: "\(error.localizedDescription)")
            self.present(alert, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
    
    
    // 新規登録
    @IBAction func signInWithMailAddressButton(_ sender: Any) {
        closeKeyboard()
        // 画面遷移
        
    }
    
    
    // Appleでサインイン
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
        if let user = authDataResult?.user {
            print("sign in with Apple as \(user.uid). Your email is: \(String(describing: user.email))")
            userDefaults.set("Apple", forKey: "howToLogIn")
            //transitionToSearchViewController()
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
        }
    }
    
    // 匿名でサインイン
    @IBAction func signInWithAnnoymouslyButton(_ sender: Any) {
        closeKeyboard()
        logInViewModel.signInWithAnnoymously().subscribe(onSuccess: { result in
            if result == true {
                self.performSegue(withIdentifier: "SearchViewController", sender: self)
            }
        }, onError: { error in
            self.labelAlert(text: "匿名のサインインに失敗しました: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    // サインアウトボタン
    @IBAction func signOutButton(_ sender: Any) {
        closeKeyboard()
        logInViewModel.signOut().subscribe(onSuccess: {
            result in
            self.labelAlert(text: "サインアウトしました")
        }, onError: {
            error in
            self.labelAlert(text: "サインアウトに失敗しました: \(error)")
        })
        .disposed(by: disposeBag)
    }
}


extension LogInViewController: UITextFieldDelegate {
    // returnキーをタップしてキーボードを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/*
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error != nil else {
            return print("GoogleSignInError: \(error.localizedDescription)")
        }
        
        guard let authentication = user.authentication else {
            return print("Google authenticationが存在しません")
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Google SignIn Failure!", error.localizedDescription)
                return
            }
            
            print("Google SignIn Success!")
            self.userDefaults.set("Google", forKey: "howToLogIn")
            self.transitionToSearchViewController()
            
        }
    }
    
    
}*/



//class MailAddressTextField: UITextField {
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return true
//    }
//}
