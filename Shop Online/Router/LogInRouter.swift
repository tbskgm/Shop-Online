//
//  LogInRouter.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/28.
//

import UIKit


/// 遷移先を制限するためのenum
enum LogInRouterEnum: String {
    case ForgetPasswordViewController
    case SignInWithMailAddressViewController
    case SearchViewController
}
/// ログイン画面のプロトコル
protocol LogInRouterProtocol {
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    func segue(withIdentifier: LogInRouterEnum)
    
    func push(withIdentifier: LogInRouterEnum)
}
/// ログイン画面のRouter
class LogInRouter: LogInRouterProtocol {
    private let vc: UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    /// 一つ前の画面に戻る処理
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        vc.dismiss(animated: animated, completion: completion)
    }
    
    /// 値の受け渡しをしない遷移
    func segue(withIdentifier: LogInRouterEnum) {
        vc.performSegue(withIdentifier: withIdentifier.rawValue, sender: nil)
    }
    
    
    /// 値の受け渡しを伴う画面遷移
    /// - Parameter WithIdentifier: 遷移先の画面を選択
    func push(withIdentifier: LogInRouterEnum) {
        let storyboard: UIStoryboard = vc.storyboard!
        
        switch withIdentifier {
        case .ForgetPasswordViewController:
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
        }
    }
}
