//
//  File.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/02/15.
//

import UIKit

class SearchRouter {
    let vc: UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    // 値の受け渡しをしない遷移
    func segue() {
        // 遷移先に必要な情報sender
        vc.performSegue(withIdentifier: "ItemDetailViewController", sender: nil)
        //vc.prepare(for: , sender: ) vcに書かないといけない
    }
    
    // 値の受け渡しを行う遷移
    func push() {
        //まずは、同じstororyboard内であることをここで定義します
        let storyboard: UIStoryboard = vc.storyboard!
        
        //ここで移動先のstoryboardを選択(今回の場合は先ほどsecondと名付けたのでそれを書きます)
        let logIn = storyboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        //画面と紐付けられるため
        
        //vc.でアクセス
        //vc.
        //logIn.
        
        //ここが実際に移動するコードとなります
        //vc.present(logIn, animated: true, completion: nil)
        //navigationの場合は画面遷移が少し違う
        //vc.pushViewController(logIn, animated: true)
        vc.navigationController?.pushViewController(logIn, animated: true)
    }
}
