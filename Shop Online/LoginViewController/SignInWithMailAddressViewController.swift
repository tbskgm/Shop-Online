//
//  SignInWithMailAddressViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/28.
//

import UIKit
import FirebaseAuth

class SignInWithMailAddressViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    //let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    //let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    let alertViewModel = AlertViewModel()
    let logInViewModel = LogInViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard Auth.auth().currentUser == nil else {
            /*別の遷移方法じゃないと落ちる*/
            self.performSegue(withIdentifier: "SearchViewController", sender: self)
            self.dismiss(animated: true) {
                print("ログイン画面に遷移しました")
            }
            return
        }
    }
    
    // labelのアラートを出す、ボタンの操作を一時停止
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
    
    // キーボードを閉じる
    func closeKeyboard() {
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        closeKeyboard()
        let isSendEmail = UserDefaults.standard.bool(forKey: "isSendEmail")
        switch isSendEmail {
        case false:
            
            guard let email = mailAddressTextField.text, email != "" else {
                return
            }
            guard let password = passwordTextField.text, password != "" else {
                return
            }
            let result = logInViewModel.signInWithMailAddress(email: email, password: password)
            let resultCase = result.case
            if resultCase == .error {
                // Crashlyticsを登録する
                //https://firebase.google.com/docs/crashlytics/customize-crash-reports?authuser=1#log-excepts
                let alert = self.alertViewModel.showAlert(title: "登録に失敗しました", message: "\(result.value)")
                self.present(alert, animated: true)
            }
        case true:
            guard let email = UserDefaults.standard.string(forKey: "Email") else {
                // https://firebase.google.com/docs/crashlytics/customize-crash-reports#log-excepts
                let alert = alertViewModel.showAlert(title: "", message: "エラーです")
                return self.present(alert, animated: true)
            }
            
            logInViewModel.reSendEmail(email: email).subscribe(
                onSuccess: { result in
                    self.labelAlert(text: "メールを再送信しました")
                }, onError: { error in
                    // https://firebase.google.com/docs/crashlytics/customize-crash-reports#log-excepts
                    // Crashlytics実装
                    let title = "メールの送信に失敗しました"
                    let alert = self.alertViewModel.showAlert(title: title, message: "\(error.localizedDescription)")
                    self.present(alert, animated: true, completion: nil)
                }
            )
            
        }
        
    }

}

extension SignInWithMailAddressViewController: UITextFieldDelegate {
    // returnキーをタップしてキーボードを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
