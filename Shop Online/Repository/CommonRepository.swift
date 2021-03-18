//
//  CommonRepository.swift
//  Shop Online
//
//  Created by 小駒翼 on 2021/03/16.
//

import Foundation
import RxSwift



enum UserDefaultsError: Error {
    case none
}
protocol UserDefaultsUseCase {
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
class UserDefaultsInteractor: UserDefaultsUseCase {
    private let userDefaults = UserDefaults.standard
    
    
    /** Property Wrappersへ移行してもいいかも*/
    /// 値の参照
    func array(forKey defaultName: String) -> [Any]? {
        return userDefaults.array(forKey: defaultName)
    }
    
    func bool(forKey defaultName: String) -> Bool {
        return userDefaults.bool(forKey: defaultName)
    }
    
    func data(forKey defaultName: String) -> Data? {
        return userDefaults.data(forKey: defaultName)
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return userDefaults.dictionary(forKey: defaultName)
    }
    
    func float(forKey defaultName: String) -> Float {
        return userDefaults.float(forKey: defaultName)
    }
    
    func integer(forKey defaultName: String) -> Int {
        return userDefaults.integer(forKey: defaultName)
    }
    
    func object(forKey defaultName: String) -> Any? {
        return userDefaults.object(forKey: defaultName)
    }
    
    func stringArray(forKey defaultName: String) -> [String]? {
        return userDefaults.stringArray(forKey: defaultName)
    }
    
    func string(forKey defaultName: String) -> String? {
        return userDefaults.string(forKey: defaultName)
    }
    
    func double(forKey defaultName: String) -> Double {
        return userDefaults.double(forKey: defaultName)
    }
    
    func url(forKey defaultName: String) -> URL? {
        return userDefaults.url(forKey: defaultName)
    }
    
    /// 値の保存
    func set(_ value: Any?, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Float, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        userDefaults.set(value, forKey: defaultName)
    }
    
    func set(_ url: URL?, forKey defaultName: String) {
        userDefaults.set(url, forKey: defaultName)
    }
    
    /// 値の削除
    func removeObject(forKey defaultName: String) {
        userDefaults.removeObject(forKey: defaultName)
    }
}
