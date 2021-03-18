//
//  SearchRepository.swift
//  Shop Online
//
//  Created by 小駒翼 on 2020/12/29.
//

import Alamofire
import RxSwift
import RxCocoa


protocol SearchRepositoryProtocol {
    func createRequestUrl(parameter: [String: String], entryUrl: String) -> String
    
    func getEncodeParameter(key: String, value: String) -> String?
    
    func rakutenRxResponse(keyword: String) -> Single<RakutenShopData>
    
    func yahooRxResponse(keyword: String) -> Single<YahooShopData>
    
    func imageRxResponse(url: String) -> Single<UIImage>
}

/// 検索画面のRepository
class SearchRepository: SearchRepositoryProtocol {
    /// 楽天API
    private let rakutenAppId = "1045652177289660162"
    private let rakutenEntryUrl = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706"
    //let exampleRakutenAPI = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?applicationId=1045652177289660162&keyword=%E7%A6%8F%E8%A2%8B&sort=%2BitemPrice"
    
    /// YahooAPI
    private let yahooClientId = "dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-"
    private let yahooEntryUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch"
    //let exampleYahooURL = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-&query=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93"
    
    /// 写真を取得する関数
    func imageRxResponse(url: String) -> Single<UIImage> {
        return Single<UIImage>.create { single -> Disposable in
            AF.request(url).response { response in
                guard let data = response.data else {
                    return
                }
                guard let image = UIImage(data: data) else {
                    return
                }
                single(.success(image))
            }
            return Disposables.create()
        }
    }
    
    /// ヤフーの検索結果を返す関数
    func yahooRxResponse(keyword: String) -> Single<YahooShopData> {
        return Single<YahooShopData>.create { single -> Disposable in
            /// URL作成に必須な要素
            let parameter = ["appid": self.yahooClientId, "query": keyword]
            /// URLの共通部分を取得
            let entryUrl = self.yahooEntryUrl
            /// URL作成
            let requestUrl = self.createRequestUrl(parameter: parameter, entryUrl: entryUrl)
            
            AF.request(requestUrl).response { response in
                guard let data = response.data else {
                    return
                }
                guard let userModel = try? JSONDecoder.init().decode(YahooShopData.self, from: data) else {
                    return
                }
                single(.success(userModel))
            }
            return Disposables.create()
        }
    }
    
    /// 楽天の検索結果を返す関数
    func rakutenRxResponse(keyword: String) -> Single<RakutenShopData> {
        return Single<RakutenShopData>.create { single -> Disposable in
            /// URL作成に必須な要素
            let parameter = ["applicationId": self.rakutenAppId, "keyword": keyword]
            /// URLの共通部分を取得
            let entryUrl = self.rakutenEntryUrl
            /// URL作成
            let requestUrl = self.createRequestUrl(parameter: parameter, entryUrl: entryUrl)
            
            AF.request(requestUrl).response { response in
                guard let data = response.data else {
                    return
                }
                guard let userModel = try? JSONDecoder.init().decode(RakutenShopData.self, from: data) else {
                    return
                }
                single(.success(userModel))
            }
            return Disposables.create()
        }
    }
    
    
    /// URLエンコード処理
    func getEncodeParameter(key: String, value: String) -> String? {
        guard let encodedInputText = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.afURLQueryAllowed) else {
            return nil
        }
        return "\(key)=\(encodedInputText)"
    }
    
    
    /// URL作成
    func createRequestUrl(parameter: [String: String], entryUrl: String) -> String {
        var parameterString = ""
        
        for key in parameter.keys {
            /// 値の取り出し
            guard let value = parameter[key] else {
                continue /// valueがなかったら次のfor文を実行する
            }
            /// すでにparameterが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            /// 値をエンコードする
            guard let encodeValue = getEncodeParameter(key: key, value: value) else {
                /// エンコードの失敗。次のfor文を実行する
                continue
            }
            /// エンコードした値をパラメータとして追加する
            parameterString += encodeValue
        }
        
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }
    
    
    /*
    //画像データを取得する関数
    func imageResponse(url: String, closure: @escaping (_ imageView: UIImage) -> Void) {
        AF.request(url).response { response in
            guard let data = response.data else {
                print("dataを取り出すことができませんでした")
                return
            }
            guard let imageView = UIImage(data: data) else {
                print("imageViewを取り出すことだできませんでした")
                return
            }
            closure(imageView)
        }
    }
    //Yahooからデータを取得する
    func YahooResponse(keyword: String, closure: @escaping (_ shopData: YahooShopData) -> Void) {
        let parameter = ["appid": yahooClientId, "query": keyword] // URL作成に必須な要素
        let entryUrl = yahooEntryUrl // URLの共通部分を取得
        let requestUrl = createRequestUrl(parameter: parameter, entryUrl: entryUrl) // URL作成
        
        AF.request(requestUrl).response { response in
            guard let data = response.data else {
                return
            }
            //let userModel = try? JSONDecoder.init().decode(YahooShopData.self, from: data)
            guard let userModel = try? JSONDecoder.init().decode(YahooShopData.self, from: data) else {
                return
            }
            print("userModel: \(String(describing: userModel))")
            closure(userModel)
        }
    }
    // 楽天からデータを取得する
    func rakutenResponse(keyword: String, closure: @escaping (_ shopData: RakutenShopData) -> Void ) {
        let parameter = ["applicationId": rakutenAppId, "keyword": keyword] // URL作成に必須な要素
        let entryUrl = rakutenEntryUrl // URLの共通部分を取得
        let requestUrl = createRequestUrl(parameter: parameter, entryUrl: entryUrl) // URL作成
        
        AF.request(requestUrl).response { response in
            guard let data = response.data else { return }
            let userModel = try? JSONDecoder.init().decode(RakutenShopData.self, from: data)
            //print("userModel: \(String(describing: userModel))")
            closure(userModel!)
        }
    }*/
}

