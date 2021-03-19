//
//  SearchRepository.swift
//  Shop OnlineTests
//
//  Created by 小駒翼 on 2021/03/15.
//

import XCTest

@testable import Shop_Online

class SearchRepositoryTests: XCTestCase {
    let searchRepository: SearchRepositoryProtocol = SearchRepository()
    let keyword = CommonWord.keyword
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // ここにセットアップコードを入れます。このメソッドは、クラス内の各テストメソッドの呼び出しの前に呼び出されます。
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // ここにティアダウンコードを入れます。このメソッドは、クラス内の各テストメソッドの呼び出し後に呼び出されます。
    }
    
    func xtestExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // これは機能テストケースの例です。
        // XCTAssert と関連する関数を使用して、テストが正しい結果を出すことを確認します。
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        // パフォーマンステストケースの例です。
        self.measure {
            // Put the code you want to measure the time of here.
            // ここに時間を計測したいコードを入れます。
        }
    }
    
    func testImageRxResponse() {
        // printでURL取得し、urlに入れる
        // successで成功,errorでXCFail入れる
        let url = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-&query=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93"
        searchRepository.imageRxResponse(url: url).subscribe(onSuccess: { result in
            print("成功")
        }, onError: { error in
            XCTFail("URLが正しくないか、処理に誤りがあるため失敗しました。")
        })
        .dispose()
    }
    
    func testYahooRxResponse() {
        searchRepository.yahooRxResponse(keyword: keyword).subscribe(onSuccess: { result in
            print("成功")
        }, onError: { error in
            XCTFail("通信処理に失敗しました: \(error.localizedDescription)")
        })
        .dispose()
    }
    
    func testRakutenRxResponse() {
        searchRepository.rakutenRxResponse(keyword: keyword).subscribe(onSuccess: { result in
            print("成功")
        }, onError: { error in
            XCTFail("失敗: \(error.localizedDescription)")
        })
        .dispose()
    }
    
    func testGetEncode() {
        let key = ""
        let value = ""
        let encodeParameter = searchRepository.getEncodeParameter(key: key, value: value)
        XCTAssertNotNil(encodeParameter) /*nilになる方法を探る*/
    }
    
    func testYahooCreateRequestUrl() {
        // requestUrl取得
        let yahooParameter = ["appid": "dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-", "query": keyword]
        let yahooEntryUrl = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch"
        let yahooRequestUrl = searchRepository.createRequestUrl(parameter: yahooParameter, entryUrl: yahooEntryUrl)
        
        // 正しいURL取得
        let yahooCorrectUrl1 = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-&query=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93"
        let yahooCorrectUrl2 = "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?query=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93&appid=dj00aiZpPTZQNjRpZllCUWFMdSZzPWNvbnN1bWVyc2VjcmV0Jng9NTE-"
        
        // 比較
        if yahooRequestUrl == yahooCorrectUrl1 {
            //print("yahooCorrectUrl1")
        } else if yahooRequestUrl == yahooCorrectUrl2 {
            //print("yahooCorrectUrl2")
        } else {
            XCTFail()
        }
        //guard yahooRequestUrl == yahooCorrectUrl1, yahooRequestUrl == yahooCorrectUrl2 else {
        //    XCTFail()
        //    return
        //}
        
        
        //XCTAssertEqual(yahooRequestUrl, yahooCorrectUrl)
    }
    
    func testRakutenCreateRequestUrl() {
        // requestURL取得
        let rakutenParameter = ["applicationId": "1045652177289660162", "keyword": keyword]
        let rakutenEntryUrl = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706"
        let rakutenRequestUrl = searchRepository.createRequestUrl(parameter: rakutenParameter, entryUrl: rakutenEntryUrl)
        
        // 正しいURL取得
        let rakutenCorrectUrl1 = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?applicationId=1045652177289660162&keyword=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93"
        let rakutenCorrectUrl2 = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?keyword=%E8%AE%83%E5%B2%90%E3%81%86%E3%81%A9%E3%82%93&applicationId=1045652177289660162"
        
        // 比較
        if rakutenRequestUrl == rakutenCorrectUrl1 {
            
        } else if rakutenRequestUrl == rakutenCorrectUrl2 {
            
        } else {
            XCTFail()
        }
        
        
        //XCTAssertEqual(rakutenRequestUrl, rakutenCorrectUrl)
    }
}

