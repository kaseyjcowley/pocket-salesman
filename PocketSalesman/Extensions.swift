//
//  Extensions.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/11/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation
import UIKit
import SwiftIcons

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff)
    }
    
    struct Custom {
        static let success = UIColor.init(hex: 0x5fdd9d)
        static let warning = UIColor.init(hex: 0xf7ee7f)
        static let danger = UIColor.init(hex: 0xef767a)
    }
    
    struct Theme {
        static let primaryBlue = UIColor.init(hex: 0x24b0fc)
    }
    
}

extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}

extension Double {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}

protocol Applyable {}

extension Applyable {
    
    @discardableResult
    func apply(closure: (Self) -> ()) -> Self {
        closure(self)
        return self
    }
    
}

extension UIView: Applyable {}
extension UIViewController: Applyable {}

extension UITextField {
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
}

extension Dictionary {
    public func map<T: Hashable, U>(transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
    
    public func map<T: Hashable, U>(transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
}
