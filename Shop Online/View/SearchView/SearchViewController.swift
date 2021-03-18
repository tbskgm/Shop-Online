//
//  SearchViewController.swift
//  Shop Online
//
//  Created by 小駒翼 on 2020/12/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import RxSwift


class SearchViewController: UIViewController {
    @IBOutlet weak var firstShopCollectioinView: UICollectionView!
    @IBOutlet weak var firstShopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondShopCollectionView: UICollectionView!
    @IBOutlet weak var secondShopHeightConstraint: NSLayoutConstraint!
    
    let searchViewModel: SearchViewModelProtocol = SearchViewModel()
    let alertViewModel: AlertViewModelProtocol = AlertViewModel()
    
    lazy var searchRouter: SearchRouterProtocol = SearchRouter(vc: self)
    
    let disposeBag = DisposeBag()
    
    /// 検索結果を保存する
    var yahooItemDatas = [YahooItemData]()
    /// 検索結果を保存する
    var rakutenItemDatas = [RakutenItemData]()
    //var imageCache = NSCache<AnyObject, UIImage>()
    /// 金額のフォーマット
    let priceFormat = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstShopCollectioinView.delegate = self
        firstShopCollectioinView.dataSource = self
        
        /// 通貨で使用する
        priceFormat.numberStyle = .currency
        
        /// 日本の表示にする
        priceFormat.currencyCode = "JPY"
    }
    
    
    /// 遷移画面にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? CollectionViewCell {
            if let webViewController = segue.destination as? ItemDetailViewController {
                
                searchRouter.push() { (ItemDetailViewController) -> Void in
                    /// 商品ページのURLを設定する
                    webViewController.itemUrl = cell.itemUrl
                }
            }
        }
    }
    
    
    /// timerIntervalで使用後消去
    @IBAction func realtimeButton(_ sender: Any) {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        let messageData = ["name": "名前", "message": "メッセージ"]
        ref.childByAutoId().setValue(messageData)
        
    }
    
}
extension SearchViewController: UICollectionViewDelegate {
}


extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// cellを表示する数を定義できる関数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return yahooItemDatas.count
        case 1:
            return rakutenItemDatas.count
        default:
            assertionFailure("想定外のtagの検出です")
            return 0
        }
    }
    
    // cellをカスタマイズできる関数
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yahooItemCell", for: indexPath) as! CollectionViewCell
            
            let itemData = yahooItemDatas[indexPath.row]
            // 商品のタイトル設定
            cell.titleLabel.text = itemData.itemName
            // 商品価格設定処理（日本通貨の形式で設定する）
            let number = NSNumber(integerLiteral: itemData.itemPrice)
            cell.priceLabel.text = priceFormat.string(from: number)
            // 商品のURL設定
            cell.itemUrl = itemData.itemUrl
            // 画像の設定処理
            let yahooImageUrl = itemData.itemImageUrl
            searchViewModel.getImageUrl(yahooImageUrl: yahooImageUrl).subscribe(onSuccess: { result in
                cell.imageView.image = result
            }, onError: { error in
                let message = "\(error.localizedDescription)"
                let alert = self.alertViewModel.showAlert(title: "", message: message)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rakutenItemCell", for: indexPath) as! CollectionViewCell
            let itemData = rakutenItemDatas[indexPath.row]
            // 商品のタイトル設定
            cell.titleLabel.text = itemData.itemName
            // 商品価格設定処理（日本通貨の形式で設定する）
            let number = NSNumber(integerLiteral: itemData.itemPrice)
            cell.priceLabel.text = priceFormat.string(from: number)
            // 商品のURL設定
            cell.itemUrl = itemData.itemUrl
            // 画像の設定処理
            let rakutenImageUrl = itemData.itemImageUrl
            searchViewModel.getImageUrl(rakutenImageUrl: rakutenImageUrl).subscribe(onSuccess: { result in
                cell.imageView.image = result
            }, onError: { error in
                let message = "\(error.localizedDescription)"
                let alert = self.alertViewModel.showAlert(title: "", message: message)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
            
            return cell
        default:
            assertionFailure("想定外の値の検出です")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yahooItemCell", for: indexPath)
            return cell
        }
    }
    
    
}
extension SearchViewController: UISearchBarDelegate {
    // キーボードのsearchボタンがタップされた時に呼び出される
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // リクエスト処理
        guard let keyword = searchBar.text else {
            print("入力文字がありません")
            return
        }
        // 入力文字数が0文字より多いかどうかチェックする
        guard keyword.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            //print("0文字より多くありません")
            return
        }
        
        /// 通信を使用し、Yahooから商品データを取得し画面に反映する
        searchViewModel.getDataFromYahoo(keyword: keyword).subscribe(onSuccess: {
            result in
            // 処理を書く
            self.yahooItemDatas = result
            
            DispatchQueue.main.async {
                self.firstShopCollectioinView.reloadData()
            }
        }, onError: { error in
            let message = "\(error.localizedDescription)"
            let alert = self.alertViewModel.showAlert(title: "", message: message)
            self.present(alert, animated: true)
        })
        .disposed(by: disposeBag)
        
        /// 通信を使用し、楽天から商品データを取得し画面に反映する
        searchViewModel.getDataFromRakuten(keyword: keyword).subscribe(onSuccess: { result in
            //処理を書く
            self.rakutenItemDatas = result
            
            DispatchQueue.main.async {
                self.secondShopCollectionView.reloadData() // Yahooの更新
            }
            
        }, onError: { error in
            let message = "\(error.localizedDescription)"
            let alert = self.alertViewModel.showAlert(title: "", message: message)
            self.present(alert, animated: true)
        })
        .disposed(by: disposeBag)
        
        
        /*
        // 通信してYahooから商品データを取得し画面に反映する(クロージャー版)
        viewModel.yahooGetData(keyword: keyword) { result in
            self.yahooItemDatas = result
            
            DispatchQueue.main.async {
                self.firstShopCollectioinView.reloadData() // Yahooの更新
            }
        }
        // 通信して楽天から商品データを取得し画面に反映する(クロージャー版)
        viewModel.rakutenGetData(keyword: keyword) { result in
            //self.rakutenItemDatas = result
            let rakutenItemDatas = result
            
            self.secondShopCollectionViewDataSource = SecondShopCollectionViewDataSource(items: rakutenItemDatas)
            self.secondShopCollectionView.delegate = self.secondShopCollectionViewDataSource
            self.secondShopCollectionView.dataSource  = self.secondShopCollectionViewDataSource
            
            DispatchQueue.main.async {
                self.secondShopCollectionView.reloadData() // 楽天市場の更新
            }
        }*/
        
        searchBar.resignFirstResponder() // キーボードを閉じる処理
    }
}

extension SearchViewController: UITextFieldDelegate {
    /// searchBar以外をタップしてキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
