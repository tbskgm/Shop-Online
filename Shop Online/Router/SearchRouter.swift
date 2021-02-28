//
//  Router.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/24.
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
         ///画面と紐付けられるため
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


enum SearchRouterEnum: String {
    case ItemDetailViewController
}
protocol SearchRouterProtocol {
    func segue()
    
    func push()
}
class SearchRouter: SearchRouterProtocol {
    private let vc: UIViewController!
    
    private init(vc: UIViewController) {
        self.vc = ItemDetailViewController()
        //self.vc = vc
    }
    
    let withIdentifier = "ItemDetailViewController"
    
    // 値の受け渡しをしない遷移
    func segue() {
        vc.performSegue(withIdentifier: withIdentifier, sender: nil)
    }
    
    // 値の受け渡しを行う遷移
    func push() {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = vc.storyboard!
        
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: withIdentifier) as! ItemDetailViewController
        
        vc.navigationController?.pushViewController(instantiateViewController, animated: true)
        /**
         /// 画面と紐付けられるため
         let vc = storyboard.instantiateViewController(withIdentifier: withIdentifier) as! ItemDetailViewController
         
         /// vc.でアクセス
         vc.
         
         /// 画面遷移
         vc.navigationController?.pushViewController(vc, animated: true)
         
         */
    }
}
