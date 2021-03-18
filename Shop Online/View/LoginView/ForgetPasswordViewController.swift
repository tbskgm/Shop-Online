//
//  ForgetPasswordViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/25.
//

import UIKit
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    
    lazy var router: LogInRouterProtocol = LogInRouter(vc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAddressTextField.delegate = self
    }
    
    /// labelのalertを出す
    func labelAlert(text: String) {
        messageLabel.isHidden = false
        sendButton.isEnabled = false
        messageLabel.text = text
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + 2) {
            self.messageLabel.isHidden = true
            self.sendButton.isEnabled = true
        }
    }
    
    
    /// パスワードを再設定する
    @IBAction func sendButton(_ sender: Any) {
        guard mailAddressTextField.text != "", let email = mailAddressTextField.text else {
            let alert = alertViewModel.showAlert(title: "", message: "メールアドレスを入力してください")
            self.present(alert, animated: true)
            return
        }
        
        // パスワードを再設定する
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                print("sendPasswordResetError: \(String(describing: error?.localizedDescription))")
                return
            }
            
            /// 明示的に設定するのではなく、デフォルトのアプリ言語を適用します。
            Auth.auth().useAppLanguage()
            
            /**
                /// 明示的に指定する場合
                Auth.auth().languageCode = "fr"
            */
                
            /// ログイン画面に戻る
            self.labelAlert(text: "メールを送信しました")
            let queue = DispatchQueue.main
            queue.asyncAfter(deadline: .now() + 2) {
                self.router.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
extension ForgetPasswordViewController: UITextFieldDelegate {
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
