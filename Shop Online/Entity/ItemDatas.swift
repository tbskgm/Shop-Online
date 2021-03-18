//
//  ShopData.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/01/12.
//

//import Foundation

// 何に使っているか不明
//struct ItemsModel {
//    var imageView: String
//    var itemName: String
//    var itemPrice: Int
//}

// Yahooのデータ構造
struct YahooShopData: Codable {
    let items: [YahooItemData]
    
    private enum CodingKeys: String, CodingKey {
        case items = "hits"
    }
}

struct YahooItemData: Codable {
    let itemName: String
    let itemPrice: Int
    let itemImageUrl: YahooImageUrl
    let itemUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case itemName = "name"
        case itemPrice = "price"
        case itemImageUrl = "image"
        case itemUrl = "url"
    }
}

struct YahooImageUrl: Codable {
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "small"
    }
}


// 楽天のデータ構造
struct RakutenShopData: Codable {
    let items: [RakutenItem]
    
    private enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}
 
struct RakutenItem: Codable {
    let item: RakutenItemData
    
    private enum CodingKeys: String, CodingKey {
        case item = "Item"
    }
}


struct RakutenItemData: Codable {
    let itemName: String
    let itemPrice: Int
    let itemImageUrl: [RakutenImageUrl]
    let itemUrl: String
    
    
    private enum CodingKeys: String, CodingKey {
        case itemImageUrl = "smallImageUrls"
        case itemName
        case itemPrice
        case itemUrl
    }
}
struct RakutenImageUrl: Codable {
    var imageUrl: String
}


