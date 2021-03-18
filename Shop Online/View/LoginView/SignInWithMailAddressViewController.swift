//
//  SignInWithMailAddressViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/28.
//

import UIKit
import FirebaseAuth
import RxSwift
import RealmSwift

class SignInWithMailAddressViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    let userDefaultsPresenter: UserDefaultsPresentation = UserDefaultsPresenter()
    
    lazy var router: LogInRouterProtocol = LogInRouter(vc: self)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        //let logInViewModel = LogInViewModel() {
        //
        //}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard Auth.auth().currentUser == nil else {
            router.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    /// labelのアラートを出す、ボタンの操作を一時停止
    func labelAlert(text: String) {
        messageLabel.isHidden = false
        signInButton.isEnabled = false
        messageLabel.text = text
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + 2) {
            self.messageLabel.isHidden = true
            self.signInButton.isEnabled = true
        }
    }
    
    /// キーボードを閉じる
    func closeKeyboard() {
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    /// サインインするボタン
    @IBAction func signInButton(_ sender: Any) {
        /// キーボードを閉じる
        closeKeyboard()
        /// 連続してボタンを押せないようにする
        signInButton.isEnabled = false
        defer {
            let queue = DispatchQueue.main
            queue.asyncAfter(deadline: .now() + 2) {
                self.signInButton.isEnabled = true
            }
        }
        
        /// メールアドレスで認証を行う
        let isSendEmail = UserDefaults.standard.bool(forKey: "isSendEmail")
        switch isSendEmail {
        case false:
            /// メールとパスワード生成
            let email = mailAddressTextField.text!
            let password = passwordTextField.text!
                
            logInViewModel.signInWithMailAddress(email: email, password: password).subscribe(onSuccess: { result in
                guard result == true else {
                    fatalError("falseは想定されていません")
                }
                self.labelAlert(text: "メールが送信されました")
            }, onError: { error in
                let alert = self.alertViewModel.showAlert(title: "", message: "\(error.localizedDescription)")
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        case true:
            /// メールアドレスを取得
            guard let email = userDefaultsPresenter.string(forKey: "Email") else {
                // https://firebase.google.com/docs/crashlytics/customize-crash-reports#log-excepts
                let alert = alertViewModel.showAlert(title: "", message: "エラーです")
                return self.present(alert, animated: true)
            }
            /// メールリンク認証を行う
            logInViewModel.sendLinkEmail(email: email).subscribe(onSuccess: { result in
                self.labelAlert(text: "メールを再送信しました")
            }, onError: { error in
                // https://firebase.google.com/docs/crashlytics/customize-crash-reports#log-excepts
                // Crashlytics実装
                let title = "メールの送信に失敗しました"
                let alert = self.alertViewModel.showAlert(title: title, message: "\(error.localizedDescription)")
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        }
    }
}


extension SignInWithMailAddressViewController: UITextFieldDelegate {
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
