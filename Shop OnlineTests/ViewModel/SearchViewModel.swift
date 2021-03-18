//
//  SearchViewModel.swift
//  Shop OnlineTests
//
//  Created by 小駒翼 on 2021/03/15.
//

import XCTest


@testable import Shop_Online


class SearchViewModelTests: XCTestCase {
    let searchViewModel: SearchViewModelProtocol = SearchViewModel()
    let keyword = CommonWord.keyword
    
    func testGetDataFromYahoo() {
        searchViewModel.getDataFromYahoo(keyword: keyword).subscribe(onSuccess: { result in
        }, onError: { error in
            XCTFail()
        })
        .dispose()
    }
    
    
    func testGetDataFromRakuten() {
        searchViewModel.getDataFromRakuten(keyword: keyword).subscribe(onSuccess: { result in
        }, onError: { error in
            XCTFail()
        })
        .dispose()
    }
    
    
    func testGetImageUrlFromYahoo() {
        var imageUrls = [YahooImageUrl]()
        
        // 非同期処理の一時停止させる
        let getDataExpecatation = self.expectation(description: "searchViewModel.getDataFromYahoo")
        getDataExpecatation.assertForOverFulfill = false
        
        // imageUrlsの取得
        searchViewModel.getDataFromYahoo(keyword: keyword).subscribe(onSuccess: { items in
            for item in items {
                let imageUrl = item.itemImageUrl
                imageUrls.append(imageUrl)
                getDataExpecatation.fulfill()
                
            }
        }, onError: { error in
            XCTFail()
        })
        .dispose()
        
        wait(for: [getDataExpecatation], timeout: 10)
        XCTAssertNotNil(imageUrls)
        
        
        
        var uiImageArray = [UIImage]()
        
        let getImageUrlExpectation = self.expectation(description: "searchViewModel.getImageUrl")
        getImageUrlExpectation.assertForOverFulfill = false
        
        for imageUrl in imageUrls {
            searchViewModel.getImageUrl(yahooImageUrl: imageUrl).subscribe(onSuccess: { uiImage in
                    uiImageArray.append(uiImage)
                    getImageUrlExpectation.fulfill()
                    
                }, onError: { error in
                    XCTFail()
                })
                .dispose()
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
        
        searchViewModel.getDataFromRakuten(keyword: keyword).subscribe(onSuccess: { items in
            for item in items {
                let imageUrl = item.itemImageUrl
                imageUrls.append(imageUrl)
                getDataExpectation.fulfill()
            }
        }, onError: { error in
            XCTFail("\(error.localizedDescription)")
            getDataExpectation.fulfill()
        })
        .dispose()
        wait(for: [getDataExpectation], timeout: 10)
        
        if imageUrls.count == 0 {
            XCTFail("配列の数が足りません")
        } else {
            print("rakutenGetDataCount: \(imageUrls.count)")
        }
        
        var uiImageArray = [UIImage]()
        
        let getImageUrlExpectation = self.expectation(description: "searchViewModel.getImageUrl")
        getImageUrlExpectation.assertForOverFulfill = false
        
        for imageUrl in imageUrls {
            searchViewModel.getImageUrl(rakutenImageUrl: imageUrl).subscribe(onSuccess: { uiImage in
                uiImageArray.append(uiImage)
                getImageUrlExpectation.fulfill()
                
            }, onError: { error in
                XCTFail()
                
            })
            .dispose()
        }
        wait(for: [getImageUrlExpectation], timeout: 10)
        
        
        if uiImageArray.count == 0 {
            XCTFail()
        } else {
            print("rakutenImageCount: \(uiImageArray.count)")
        }
    }
}
