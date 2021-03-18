//
//  CollectionViewCell.swift
//  Shop Online
//
//  Created by 小駒翼 on 2020/12/28.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! /// 商品画像
    @IBOutlet weak var titleLabel: UILabel! /// 商品名
    @IBOutlet weak var priceLabel: UILabel! /// 商品価格
    var itemUrl: String? /// 商品ページのURL。遷移先の画面で利用する
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// cellのカスタマイズをこちらに書く
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        /// 現在の設定の取得
        let cellSize = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        /// 変更を加える
        var frame = cellSize.frame /// frameにサイズ情報が格納
        frame.origin = CGPoint(x: 0, y: 0) /// 基準地点を設定
        frame.size.width = CGFloat(Int(((self.superview)?.frame.width)! / 2) - 5)
        frame.size.height = CGFloat(Int(((self.superview)?.frame.height)! / 2) - 5)
        cellSize.frame = frame
        return cellSize
    }
    
}
