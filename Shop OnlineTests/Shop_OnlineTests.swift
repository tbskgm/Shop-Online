//  Shop_OnlineTests.swift
//  Shop OnlineTests
//
//  Created by 小駒翼 on 2020/12/21.

import XCTest

@testable import Shop_Online

let keyword = "讃岐うどん"

//class Shop_OnlineTests: XCTestCase {
class TestSearchRepository: XCTestCase {
    //ViewModel, Repositoryを書く
    // UIは書かない。手動でテストしてます
    //〇〇のテストみたいにする
    //関数名のtestの前にxをつけると消える
    //非同期でwaitを書く
    
    let searchRepository: SearchRepositoryProtocol = SearchRepository()
    
    
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
        searchRepository.imageRxResponse(url: url).subscribe(
            onSuccess: { result in
                print("成功")
            }, onError: { error in
                XCTFail("URLが正しくないか、処理に誤りがあるため失敗しました。")
            })
            .dispose()
    }
    
    func testYahooRxResponse() {
        searchRepository.yahooRxResponse(keyword: keyword).subscribe(
            onSuccess: { result in
                print("成功")
            }, onError: { error in
                XCTFail("通信処理に失敗しました: \(error.localizedDescription)")
            })
            .dispose()
    }
    
    func testRakutenRxResponse() {
        searchRepository.rakutenRxResponse(keyword: keyword).subscribe(
            onSuccess: { result in
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


class TestLogInRepository: XCTestCase {
    let logInRepository: LogInRepositoryProtocol = LogInRepository()
    
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
    
    func testLogInState() {
        let logInMethods = ["Apple", "Google", "none", "gest", "mailAddress"]
        
        for logInMethod in logInMethods {
            
            logInRepository.logInState(howToLogIn: logInMethod).subscribe(
                onSuccess: { result in
                    switch logInMethod {
                    case "none":
                        XCTAssertEqual(result, "現在ログインされていません")
                    case "gest":
                        XCTAssertEqual(result, "前回は匿名でログインされました")
                    case "mailAddress":
                        XCTAssertEqual(result, "前回はメールアドレスでログインされました")
                    case "Apple":
                        XCTAssertEqual(result, "前回はAppleでログインされました")
                    case "Google":
                        XCTAssertEqual(result, "前回はGoogleでログインされました")
                    default:
                        fatalError("新たなログイン方法が追加されているので修正してください")
                    }
                }, onError: { error in
                    XCTFail("想定外の値の検出")
                })
                .dispose()
        }
    }
    
    func testLogInWithMailAddress() {
        let failreEmail = "shop_Online@example.com"
        let failrePassword = "かf4h0gfんkd4h3みgien5gおsp7eさn21ka3nd"
        
        logInRepository.logInWithMailAddress(email: failreEmail, password: failrePassword).subscribe(
            onSuccess: { result in
                XCTFail("このアカウントは存在しません")
            }, onError: { error in
                print("成功")
            })
            .dispose()
        
        let successEmail = "yxiaoju01@gmail.com"
        let successPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        logInRepository.logInWithMailAddress(email: successEmail, password: successPassword).subscribe(
            onSuccess: { result in
                print("成功")
            }, onError: { error in
                XCTFail("ログイン処理に誤りがあります: \(error.localizedDescription)")
            })
            .dispose()
        
    }
    
    func testSignInWithMailAddress() {
        // すでにログインしているアカウントからはエラーが起きるようにテストする
        // 
    }
    
    func testReSendEmail() {
        
    }
    
    func testSendAuthenticationLinkEmail() {
        let registeredEmail = "yxiaoju01@gmail.com"
        
        logInRepository.sendAuthenticationLinkEmail(email: registeredEmail).subscribe(
            onSuccess: { result in
                XCTFail("このメールアドレスはすでに登録されているはずです。")
            }, onError: { error in
                print("成功")
            })
            .dispose()
        
        let notRegistedEmail = "shop_Online@example.com"
        logInRepository.sendAuthenticationLinkEmail(email: notRegistedEmail).subscribe(
            onSuccess: { result in
                print("成功")
            }, onError: { error in
                XCTFail("失敗")
            })
    }
    
    func testSignInWithAnnoynously() {
        logInRepository.signInWithAnnoymously().subscribe(
            onSuccess: { result in
                
            }, onError: { error in
                XCTFail("匿名ログイン失敗")
            })
            .dispose()
    }
    
    func testSignOut() {
        logInRepository.signOut().subscribe(
            onSuccess: { result in
                // 成功
            }, onError: { error in
                XCTFail()
            })
            .dispose()
    }
    
    
}

class TestViewModel: XCTestCase {
    let logInViewModel: LogInViewModelProtocol = LogInViewModel()
    let searchViewModel: SearchViewModelProtocol = SearchViewModel()
    
    override func setUpWithError() throws {
        // ここにセットアップコードを入れます。このメソッドは、クラス内の各テストメソッドの呼び出しの前に呼び出されます。
    }

    override func tearDownWithError() throws {
        // ここにティアダウンコードを入れます。このメソッドは、クラス内の各テストメソッドの呼び出し後に呼び出されます。
    }
    
    func xtestExample() throws {
        // これは機能テストケースの例です。
        // XCTAssert と関連する関数を使用して、テストが正しい結果を出すことを確認します。
    }
    
    func testGetDataFromYahoo() {
        searchViewModel.getDataFromYahoo(keyword: keyword).subscribe(
            onSuccess: { result in
            }, onError: { error in
                XCTFail()
            })
            .dispose()
    }
    
    
    func testGetDataFromRakuten() {
        searchViewModel.getDataFromRakuten(keyword: keyword).subscribe(
            onSuccess: { result in
            }, onError: { error in
                XCTFail()
            })
    }
    
    
    func testGetImageUrlFromYahoo() {
        var imageUrls = [YahooImageUrl]()
        
        // 非同期処理の一時停止させる
        let getDataExpecatation = self.expectation(description: "searchViewModel.getDataFromYahoo")
        getDataExpecatation.assertForOverFulfill = false
        
        // imageUrlsの取得
        searchViewModel.getDataFromYahoo(keyword: keyword).subscribe(
            onSuccess: { items in
                for item in items {
                    let imageUrl = item.itemImageUrl
                    imageUrls.append(imageUrl)
                    getDataExpecatation.fulfill()
                    
                }
            }, onError: { error in
                XCTFail()
            })
        
        wait(for: [getDataExpecatation], timeout: 10)
        XCTAssertNotNil(imageUrls)
        
        
        
        var uiImageArray = [UIImage]()
        
        let getImageUrlExpectation = self.expectation(description: "searchViewModel.getImageUrl")
        getImageUrlExpectation.assertForOverFulfill = false
        
        for imageUrl in imageUrls {
            searchViewModel.getImageUrl(yahooImageUrl: imageUrl).subscribe(
                onSuccess: { uiImage in
                    uiImageArray.append(uiImage)
                    getImageUrlExpectation.fulfill()
                    
                }, onError: { error in
                    XCTFail()
                })
        }
        wait(for: [getImageUrlExpectation], timeout: 10)
        XCTAssertNotNil(uiImageArray)
    }
    
    func testGetImageUrlFromRakuten() {
        var imageUrls = [[RakutenImageUrl]]()
        //let expectationCount = 30
        
        let getDataExpectation = self.expectation(description: "searchViewModel.getDataFromRakuten")
        //getDataExpectation.expectedFulfillmentCount = expectationCount
        getDataExpectation.assertForOverFulfill = false
        
        searchViewModel.getDataFromRakuten(keyword: keyword).subscribe(
            onSuccess: { items in
                for item in items {
                    let imageUrl = item.itemImageUrl
                    imageUrls.append(imageUrl)
                    getDataExpectation.fulfill()
                }
            }, onError: { error in
                XCTFail("\(error.localizedDescription)")
                getDataExpectation.fulfill()
            })
        //self.waitForExpectations(timeout: 2, handler: nil)
        wait(for: [getDataExpectation], timeout: 10)
        
        if imageUrls.count == 0 {
            XCTFail("配列の数が足りません")
        } else {
            print("rakutenGetDataCount: \(imageUrls.count)")
        }
        
        var uiImageArray = [UIImage]()
        
        let getImageUrlExpectation = self.expectation(description: "searchViewModel.getImageUrl")
        getImageUrlExpectation.assertForOverFulfill = false
        //getImageUrlExpectation.expectedFulfillmentCount = expectationCount
        
        for imageUrl in imageUrls {
            searchViewModel.getImageUrl(rakutenImageUrl: imageUrl).subscribe(
                onSuccess: { uiImage in
                    uiImageArray.append(uiImage)
                    getImageUrlExpectation.fulfill()
                    
                }, onError: { error in
                    XCTFail()
                    
                })
        }
        //waitForExpectations(timeout: 2, handler: nil)
        wait(for: [getImageUrlExpectation], timeout: 10)
        
        
        if uiImageArray.count == 0 {
            XCTFail()
        } else {
            print("rakutenImageCount: \(uiImageArray.count)")
        }
    }
    
    
    func testLogInState() {
        logInViewModel.logInState().subscribe(
            onSuccess: { result in
                if result == "nil" {
                    let bool = UserDefaults.standard.string(forKey: "howToLogIn")
                    XCTAssertNil(bool)
                } else {
                    let bool = UserDefaults.standard.string(forKey: "howToLogIn")
                    XCTAssertNotNil(bool)
                }
            }, onError: { error in
                XCTFail()
            })
            .dispose()
    }
    
    func testLogInWithMailAddress() {
        let registeredEmail = "yxiaoju01@gmail.com"
        let registeredPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        logInViewModel.logInWithMailAddress(email: registeredEmail, password: registeredPassword).subscribe(
            onSuccess: { result in
                if result != true {
                    XCTFail()
                }
            }, onError: { error in
                XCTFail("error : \(error.localizedDescription)")
            })
            .dispose()
        
        let notRegisteredEmail = "Shop_Online@example.com"
        let notRegisteredPassword = "i1gff3haq2ka7gl0vgin4igjymc8v4n6gao9lhndf6hrcu"
        logInViewModel.logInWithMailAddress(email: notRegisteredEmail, password: notRegisteredPassword).subscribe(
            onSuccess: { result in
                XCTFail()
            }, onError: { error in
                print("error: \(error.localizedDescription)")
            })
            .dispose()
    }
    
    func testSignInWithMailAddress() {
        let developEmail = "yxiaoju01@gmail.com"
        let developPassword = "jg8nfe39dm21gjsn8arxp4wgu5snusmablcr3njgnjrlsxr"
        let developResult = logInViewModel.signInWithMailAddress(email: developEmail, password: developPassword)
        let developResultCase = developResult.case
        switch developResultCase {
        case .isRegistered:
            break // 成功
        case .error:
            XCTFail("\(developResult.value)")
        case .sendEmail:
            XCTFail("すでに登録されているはずです。")
        }
        
        let fakeEmail = "Shop_Online@example.com"
        let fakePassword = "fdexiohdov2f37lp5nfortr4d0psc9hfefhssn83s74gks9nhcw53"
        let fakeResult = logInViewModel.signInWithMailAddress(email: fakeEmail, password: fakePassword)
        let fakeResultCase = fakeResult.case
        switch fakeResultCase {
        case .isRegistered:
            XCTFail("存在しないアカウントです")
        case .error:
            XCTFail("\(fakeResult.value)")
        case .sendEmail:
            break // 成功
        }
    }
    
    func testReSendEmail() {
        let fakeEmail = "Shop_Online@example.com"
        let fakeExpectation = self.expectation(description: "fakeReSendEmail")
        logInViewModel.reSendEmail(email: fakeEmail).subscribe(
            onSuccess: { result in
                fakeExpectation.fulfill()
            }, onError: { error in
                XCTFail("\(error.localizedDescription)")
            })
        wait(for: [fakeExpectation], timeout: 5)
        
        let developEmail = "yxiaoju01@gmail.com"
        let developExpectation = self.expectation(description: "developReSendEmail")
        logInViewModel.reSendEmail(email: developEmail).subscribe(
            onSuccess: { result in
                XCTFail()
            }, onError: { error in
                developExpectation.fulfill()
            })
        wait(for: [developExpectation], timeout: 5)
        
        
        /*let fakeEmail = "Shop_Online@example.com"
        
        let fakeExpectation = self.expectation(description: "fakeReSendEmail")
        let fakeResult = logInViewModel.reSendEmail(email: fakeEmail)
        if fakeResult == "true" {
            return // 成功
        } else {
            XCTFail()
        }
        
        let developEmail = "yxiaoju01@gmail.com"
        let developResult = logInViewModel.reSendEmail(email: developEmail)
        if developResult == "true" {
            XCTFail()
        } else {
            XCTFail()
        }*/
    }
    
    func testSignInWithAnnoymously() {
        logInViewModel.signInWithAnnoymously().subscribe(
            onSuccess: { result in
                // 成功
            }, onError: { error in
                print("error: \(error.localizedDescription)")
                XCTFail()
            })
            .dispose()
    }
    
    func testSignOut() {
        logInViewModel.signOut().subscribe(
            onSuccess: { result in
                // 成功
            }, onError: { error in
                XCTFail()
            })
            .dispose()
    }
    
    func testPerformanceExample() throws {
        // パフォーマンステストケースの例です。
        self.measure {
            // ここに時間を計測したいコードを入れます。
        }
    }
    
    
}
