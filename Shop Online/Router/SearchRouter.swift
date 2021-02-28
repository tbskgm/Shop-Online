//
//  Router.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/24.
//

import UIKit



enum SearchRouterEnum: String {
    case ItemDetailViewController
}
protocol SearchRouterProtocol {
    func segue()
    
    func push()
}
class SearchRouter: SearchRouterProtocol {
    private let vc: UIViewController!
    private let withIdentifier: String!
    private init(vc: UIViewController) {
        //self.vc = vc
        
        // 他のViewControllerが存在しないのでハードコードしている
        self.vc = ItemDetailViewController()
        self.withIdentifier = "ItemDetailViewController"
    }
    
    
    // 値の受け渡しをしない遷移
    func segue() {
        vc.performSegue(withIdentifier: withIdentifier, sender: nil)
    }
    
    /// 値の受け渡しを行う遷移
    func push() {
        let storyboard: UIStoryboard = vc.storyboard!
        
        /// 移動先のstoryboardを選択
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: withIdentifier) as! ItemDetailViewController
        
        /// 画面遷移
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
