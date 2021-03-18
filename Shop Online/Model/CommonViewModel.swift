//
//  CommonViewModel.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/03/16.
//

import Foundation
import RxSwift

/// userDefaults
protocol UserDefaultsPresentation {
    
    func array(forKey defaultName: String) -> [Any]?
    
    func bool(forKey defaultName: String) -> Bool
    
    func data(forKey defaultName: String) -> Data?
    
    func dictionary(forKey defaultName: String) -> [String : Any]?
    
    func float(forKey defaultName: String) -> Float
    
    func integer(forKey defaultName: String) -> Int
    
    func object(forKey defaultName: String) -> Any?
    
    func stringArray(forKey defaultName: String) -> [String]?
    
    func string(forKey defaultName: String) -> String?
    
    func double(forKey defaultName: String) -> Double
    
    func url(forKey defaultName: String) -> URL?
    
    func set(_ value: Any?, forKey defaultName: String)
    
    func set(_ value: Int, forKey defaultName: String)
    
    func set(_ value: Float, forKey defaultName: String)
    
    func set(_ value: Double, forKey defaultName: String)
    
    func set(_ value: Bool, forKey defaultName: String)
    
    func set(_ url: URL?, forKey defaultName: String)
}
class UserDefaultsPresenter: UserDefaultsPresentation {
    private let userDefaultsInteractor: UserDefaultsUseCase = UserDefaultsInteractor()
    
    
    /// 値の参照
    func array(forKey defaultName: String) -> [Any]? {
        return userDefaultsInteractor.array(forKey: defaultName)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        return userDefaultsInteractor.bool(forKey: defaultName)
    }
    
    func data(forKey defaultName: String) -> Data? {
        return userDefaultsInteractor.data(forKey: defaultName)
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return userDefaultsInteractor.dictionary(forKey: defaultName)
    }
    
    func float(forKey defaultName: String) -> Float {
        return userDefaultsInteractor.float(forKey: defaultName)
    }
    
    func integer(forKey defaultName: String) -> Int {
        return userDefaultsInteractor.integer(forKey: defaultName)
    }
    
    func object(forKey defaultName: String) -> Any? {
        return userDefaultsInteractor.object(forKey: defaultName)
    }
    
    func stringArray(forKey defaultName: String) -> [String]? {
        return userDefaultsInteractor.stringArray(forKey: defaultName)
    }
    
    func string(forKey defaultName: String) -> String? {
        return userDefaultsInteractor.string(forKey: defaultName)
    }
    
    func double(forKey defaultName: String) -> Double {
        return userDefaultsInteractor.double(forKey: defaultName)
    }
    
    func url(forKey defaultName: String) -> URL? {
        return userDefaultsInteractor.url(forKey: defaultName)
    }
    
    /// 値の保存
    func set(_ value: Any?, forKey defaultName: String) {
        userDefaultsInteractor.set(value, forKey: defaultName)
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        userDefaultsInteractor.set(value, forKey: defaultName)
    }
    
    func set(_ value: Float, forKey defaultName: String) {
        userDefaultsInteractor.set(value, forKey: defaultName)
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        userDefaultsInteractor.set(value, forKey: defaultName)
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        userDefaultsInteractor.set(value, forKey: defaultName)
    }
    
    func set(_ url: URL?, forKey defaultName: String) {
        userDefaultsInteractor.set(url, forKey: defaultName)
    }
}
