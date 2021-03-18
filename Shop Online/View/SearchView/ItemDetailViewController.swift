//
//  ItemDetailViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/01.
//

import UIKit
import WebKit

class ItemDetailViewController: UIViewController {
    /// 商品ページのURL
    var itemUrl: String?
    /// 商品ページを参照するためのWebView
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// WebViewのurlを読み込ませてWebページを表示させる
        guard let itemUrl = itemUrl else {
            return
        }
        guard let url = URL(string: itemUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
}
