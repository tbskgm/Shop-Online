//
//  SecondShopCollectionViewDataSource.swift
//  Shop Online
//
//  Created by 小駒翼 on 2020/12/31.
//

import UIKit

class SecondShopCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /*
    fileprivate var items = [ItemsModel]()
    init(items: [ItemsModel]) {
        self.items = items
    }
    
    fileprivate var items = [RakutenItemData]()
    fileprivate let priceFormat = NumberFormatter() // 金額のフォーマット
    let viewModel = SearchViewModel()
    
    init(items: [RakutenItemData]) {
        self.items = items
        
        priceFormat.numberStyle = .currency //通貨で使用する
        priceFormat.currencyCode = "JPY" //日本の表示にする
    }*/
    
    //cellを表示する数を定義できる関数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return items.count
        return 0
    }
    
    //cellをカスタマイズできる関数
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rakutenItemCell", for: indexPath) as! CollectionViewCell
        /*
        let itemData = items[indexPath.row]
        // 商品のタイトル設定
        cell.titleLabel.text = itemData.itemName
        // 商品価格設定処理（日本通貨の形式で設定する）
        let number = NSNumber(integerLiteral: itemData.itemPrice)
        cell.priceLabel.text = priceFormat.string(from: number)
        // 商品のURL設定
        cell.itemUrl = itemData.itemUrl
        // 画像の設定処理
        let urls = itemData.itemImageUrl
        viewModel.rakutenGetImageUrl(urls: urls) { result in
            cell.imageView.image = result
        }
        */
        return cell
    }
    
    /*
    //cellのサイズを定義できる関数
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width / 2) - 50
        //let width = 150
        let height = width / 2
        
        return CGSize(width: width, height: height)
    }*/
}
