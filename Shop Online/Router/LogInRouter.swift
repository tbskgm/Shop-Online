//
//  LogInRouter.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/28.
//

import UIKit



enum LogInRouterEnum: String {
    case ForgetPasswordViewController
    case SignInWithMailAddressViewController
    case SearchViewController
}
protocol LogInRouterProtocol {
    func segue(withIdentifier: LogInRouterEnum)
    
    func push(withIdentifier: LogInRouterEnum)
}
class LogInRouter: LogInRouterProtocol {
    private let vc: UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    // 値の受け渡しをしない遷移
    func segue(withIdentifier: LogInRouterEnum) {
        vc.performSegue(withIdentifier: withIdentifier.rawValue, sender: nil)
    }
    
    
    
    // 値の受け渡しを行う遷移
    func push(withIdentifier: LogInRouterEnum) {
        let storyboard: UIStoryboard = vc.storyboard!
        
        switch withIdentifier {
        case .ForgetPasswordViewController:
            // MARK: - Properties
            /// 移動先のstoryboardを選択
            let logIn = storyboard.instantiateViewController(withIdentifier: withIdentifier.rawValue) as! ForgetPasswordViewController
            vc.navigationController?.pushViewController(logIn, animated: true)
        case .SignInWithMailAddressViewController:
            /// 移動先のstoryboardを選択
            let logIn = storyboard.instantiateViewController(withIdentifier: withIdentifier.rawValue) as! SignInWithMailAddressViewController
            vc.navigationController?.pushViewController(logIn, animated: true)
        case .SearchViewController:
            /// 移動先のstoryboardを選択
            let logIn = storyboard.instantiateViewController(withIdentifier: withIdentifier.rawValue) as! SearchViewController
            vc.navigationController?.pushViewController(logIn, animated: true)
        /**
         /// 画面と紐付けられるため
         let logIn = storyboard.instantiateViewController(withIdentifier: withIdentifier.rawValue) as! ForgetPasswordViewController
         vc.navigationController?.pushViewController(logIn, animated: true)
         
         /// vc.でアクセス
         logIn.
         
         /// 画面遷移
         logIn.navigationController?.pushViewController(logIn, animated: true)
         
         */
        }
    }
}
