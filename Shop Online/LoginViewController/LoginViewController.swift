//
//  LoginViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseUI
import Firebase
import FirebaseCrashlytics

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordSwitch: UISwitch!
    @IBOutlet weak var showLogInStateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    //let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    //let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    
    let alertViewModel = AlertViewModel()
    let logInViewModel = LogInViewModel()
    
    
    var authHandle: AuthStateDidChangeListenerHandle?
    let userDefaults = UserDefaults.standard
    var firstTimeSetup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // ログイン状況を確認してlabelにこのテキストを書く
        logInViewModel.logInState().subscribe(
            onSuccess: { result in
                if result == "nil" {
                    self.showLogInStateLabel.text = "ログインされたことがないので新規登録をお願い致します。"
                } else {
                    self.showLogInStateLabel.text = result
                }
            }, onError: { error in
                print("error: \(error)")
                fatalError()
            })
            .dispose()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil, firstTimeSetup == true {
            //print("自動ログインします")
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
        } else {
            //print("自動ログインできませんでした")
        }
        
        // ユーザーのログイン状態が変更される度に呼び出され、変更される度に実行したい処理をここに書きます。
        authHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // ログイン状態が変更された時の処理を書く
            print("addStateDidChangeListenerに入る")
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
        
        // ログイン処理
        logInViewModel.logInWithMailAddress(email: email, password: password).subscribe(onSuccess: {
            result in
            print("logInWithMailAddressのperformSegueを実行します")
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
            self.userDefaults.removeObject(forKey: "isSendEmail")
        }, onError: {
            error in
            let alert = self.alertViewModel.showAlert(title: "", message: "\(error.localizedDescription)")
            self.present(alert, animated: true, completion: nil)
        })
        .dispose()
        /*
        // ログイン
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // Firebaseにかいてあったからある(何するのか不明)
            guard let strongSelf = self else {
                return
            }
            
            guard let user = authResult?.user, error == nil else {
                print("サインインに失敗しました:" ,error!.localizedDescription)
                return
            }
            print("サインインに成功しました", user.email!)
        }*/
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
        logInViewModel.signInWithAnnoymously().subscribe(onSuccess: {
            result in
            if result == true {
                self.performSegue(withIdentifier: "SearchViewController", sender: self)
            }
        }, onError: {
            error in
            self.labelAlert(text: "匿名のサインインに失敗しました: \(error)")
        })
        .dispose()
        /*Auth.auth().signInAnonymously { (authResult, error) in
            guard let user = authResult?.user, error == nil else {
                print("匿名サインインに失敗しました: \(error!.localizedDescription)")
                let alert = self.alertViewModel.showAlert(title: "", message: "匿名サインインに失敗しました: \(error!.localizedDescription)")
                return self.present(alert, animated: true)
            }
            
            print("匿名サインインに成功しました", user.uid)
            self.userDefaults.set("gest", forKey: "howToLogIn")
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
        }*/
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
        .dispose()
        /*
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("アインアウト成功")
            userDefaults.set("none", forKey: "howToLogIn")
        } catch let signOutError as NSError {
            print ("サインアウトに失敗しました: %@", signOutError)
        }*/
    }
    
    
    // ログイン画面に戻る処理
    @IBAction func backLogInViewController(_ sugue: UIStoryboardSegue) {
        // 本気で始める参照
    }
    
}


extension LoginViewController: UITextFieldDelegate {
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
