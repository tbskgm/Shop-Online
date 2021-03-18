//
//  Router.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/24.
//

import UIKit


/// 遷移先を制限するためのenum
enum SearchRouterEnum: String {
    case ItemDetailViewController
}
/// 検索画面のプロトコル
protocol SearchRouterProtocol {
    func dismiss(animated: Bool, completion: @escaping () -> Void)
    
    func segue()
    
    /** 遷移先が他にないのでハードコードしている */
    func push(closure: (_ viewController: ItemDetailViewController) -> Void)
}
/// 検索画面のRouter
class SearchRouter: SearchRouterProtocol {
    private let vc: UIViewController!
    private let withIdentifier: String!
    
    init(vc: UIViewController) {
        self.vc = vc
        /** 遷移先が他にないのでハードコードしている */
        self.withIdentifier = "ItemDetailViewController"
    }
    
    /// 一つ前の画面に戻る処理
    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        vc.dismiss(animated: animated, completion: completion)
    }
    
    /// 値の受け渡しをしない遷移
    func segue() {
        vc.performSegue(withIdentifier: withIdentifier, sender: nil)
    }
    /// 値の受け渡しを伴った画面遷移
    func push(closure: (_ viewController: ItemDetailViewController) -> Void) {
        let storyboard = vc.storyboard!
        
        /// 移動先のstoryboardを選択
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: withIdentifier) as! ItemDetailViewController
        /// 必要な情報を保存する
        closure(instantiateViewController)
        /// 画面遷移
        vc.navigationController?.pushViewController(instantiateViewController, animated: true)
    }
}
