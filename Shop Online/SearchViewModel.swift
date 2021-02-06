//
//  SearchViewModel.swift
//  Shop Online
//
//  Created by 小駒翼 on 2020/12/29.
//

import RxSwift
import RxCocoa


protocol AlertViewModelProtocol {
    // メッセージが標準的な太さになる
    func showAlert(title: String, message: String) -> UIAlertController
    
    // メッセージが太字になる
    func showAlert(message: String) -> UIAlertController
    
    func goToSettings(title: String, message: String) -> UIAlertController
}

protocol LogInViewModelProtocol {
    func logInState() -> Single<String>
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool>
    
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String)
    
    func reSendEmail(email: String) -> Single<Bool>
    
    func signInWithAnnoymously() -> Single<Bool>
    
    func signOut() -> Single<Bool>
}

protocol SearchViewModelProtocol {
    func getDataFromRakuten(keyword: String) -> Single<[RakutenItemData]>
    
    func getDataFromYahoo(keyword: String) -> Single<[YahooItemData]>
    
    func getImageUrl(yahooImageUrl: YahooImageUrl) -> Single<UIImage>
    
    func getImageUrl(rakutenImageUrl: [RakutenImageUrl]) -> Single<UIImage>
}


class SearchViewModel: SearchViewModelProtocol {
    let communicationRepository: SearchRepositoryProtocol = SearchRepository()
    
    
    // Yahooから商品データを取ってくる
    func getDataFromYahoo(keyword: String) -> Single<[YahooItemData]> {
        return self.communicationRepository.yahooRxResponse(keyword: keyword).map { yahooShopData -> [YahooItemData] in
            let items = yahooShopData.items
            return items
        }
    }
    
    
    // 楽天から商品データを取ってくる
    func getDataFromRakuten(keyword: String) -> Single<[RakutenItemData]> {
        return self.communicationRepository.rakutenRxResponse(keyword: keyword).map { rakutenShopData -> [RakutenItemData] in
            print("viewModelのgetDataFromRakuten入")
            var itemDatas = [RakutenItemData]()
            //商品のリストに追加
            let items = rakutenShopData.items
            for item in items {
                itemDatas.append(item.item)
            }
            return itemDatas
        }
    }
    
    
    func getImageUrl(yahooImageUrl: YahooImageUrl) -> Single<UIImage> {
        let firstImageUrl = yahooImageUrl // 一枚目の写真の構造体にアクセス
        let url = firstImageUrl.imageUrl
        print("yahooImageUrl: \(url)")
        return communicationRepository.imageRxResponse(url: url).map { uiImage -> UIImage in
            return uiImage
        }
    }
    
    func getImageUrl(rakutenImageUrl: [RakutenImageUrl]) -> Single<UIImage> {
        let firstImageUrl = rakutenImageUrl[0] // 一枚目の写真の構造体にアクセス
        let url = firstImageUrl.imageUrl
        print("rakutenImageUrl: \(url)")
        return communicationRepository.imageRxResponse(url: url)
        /*return self.communicationRepository.imageRxResponse(url: url).map { uiImage -> UIImage in
            return uiImage
        }*/
    }
    
    /*
    // Yahoo Shoppingから商品データを取ってくる
    func yahooGetData(keyword: String, closure: @escaping (_ shopData: [YahooItemData]) -> Void) {
        communicationRepository.YahooResponse(keyword: keyword) { result in
            var itemDatas = [YahooItemData]()
            // 商品のリストに追加
            let items = result.items
            for item in items {
                itemDatas.append(item)
            }
            closure(itemDatas)
        }
    }
    // 楽天から商品データを取ってくる
    func rakutenGetData(keyword: String, closure: @escaping (_ shopData: [RakutenItemData]) -> Void) {
        communicationRepository.rakutenResponse(keyword: keyword) { result in
            var itemDatas = [RakutenItemData]()
            //商品のリストに追加
            let items = result.items
            for item in items {
                itemDatas.append(item.item)
            }
            closure(itemDatas)
        }
    }
    // 画像を取得する
    func yahooGetImageUrl(url: YahooImageUrl, closure: @escaping (_ imageView: UIImage) -> Void) {
        var firstImageUrl: YahooImageUrl { url } // 一枚目の写真の構造体にアクセス
        var url: String { firstImageUrl.imageUrl }
        communicationRepository.imageResponse(url: url) { result in
            closure(result)
        }
    }
    // 画像を取得する
    func rakutenGetImageUrl(urls: [RakutenImageUrl], closure: @escaping (_ imageView: UIImage) -> Void) {
        var firstImageUrl: RakutenImageUrl { urls[0] } // 一枚目の写真の構造体にアクセス
        var url: String { firstImageUrl.imageUrl }
        communicationRepository.imageResponse(url: url) { result in
            closure(result)
        }
    }*/
}

// アラートのModel
class AlertViewModel: AlertViewModelProtocol {
    func showAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(close)
        return alert
    }
    func showAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(close)
        return alert
    }
    
    //アクセス許可が降りていない時に設定画面へ飛ぶ処理
    func goToSettings(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        let goToSettings = UIAlertAction(title: "設定へ移動", style: UIAlertAction.Style.default) { (UIAlertAction) in
            let url = URL(string:UIApplication.openSettingsURLString)! // URL取得
            UIApplication.shared.open(url, options: [:], completionHandler: nil) // URLを開く処理
        }
        alert.addAction(close)
        alert.addAction(goToSettings)
        return alert
    }
}



class LogInViewModel: LogInViewModelProtocol {
    let logInRepository: LogInRepositoryProtocol = LogInRepository()
    let userDefaults = UserDefaults.standard
    
    /*func logInState() -> Single<String> {
        return logInRepository.logInState()
    }*/
    func logInState() -> Single<String> {
        guard let howToLogIn = self.userDefaults.string(forKey: "howToLogIn") else {
            return Single<String>.create { single -> Disposable in
                single(.success("nil"))
                return Disposables.create()
            }
        }
        return logInRepository.logInState(howToLogIn: howToLogIn)
    }
    
    func logInWithMailAddress(email: String, password: String) -> Single<Bool> {
        return logInRepository.logInWithMailAddress(email: email, password: password).map { bool -> Bool in
            if bool == true {
                self.userDefaults.set("mailAddress", forKey: "howToLogIn")
            }
            return bool
        }
    }
    
    func signInWithMailAddress(email: String, password: String) -> (case: SignInWithMailAddressState, value: String) {
        let result = logInRepository.signInWithMailAddress(email: email, password: password)
        let resultCase = result.case
        if resultCase == .sendEmail {
            userDefaults.set(true, forKey: "isSendEmail")
        }
        return result
    }
    
    func reSendEmail(email: String) -> Single<Bool> {
        return logInRepository.reSendEmail(email: email)
    }
    
    func signInWithAnnoymously() -> Single<Bool> {
        logInRepository.signInWithAnnoymously().map { bool -> Bool in
            if bool == true {
                self.userDefaults.set("gest", forKey: "howToLogIn")
            }
            return bool
        }
    }
    
    func signOut() -> Single<Bool> {
        logInRepository.signOut().map{ bool -> Bool in
            self.userDefaults.set("none", forKey: "howToLogIn")
            return bool
        }
    }
    
}

