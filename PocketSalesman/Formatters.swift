//
//  CurrencyFormatter.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 8/25/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import Eureka

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        var str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if !string.isEmpty, numberStyle == .currency && !string.contains(currencySymbol) {
            // Check if the currency symbol is at the last index
            if let formattedNumber = self.string(from: 1), String(formattedNumber[formattedNumber.index(before: formattedNumber.endIndex)...]) == currencySymbol {
                // This means the user has deleted the currency symbol. We cut the last number and then add the symbol automatically
                str = String(str[..<str.index(before: str.endIndex)])
                
            }
        }
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
    }
}

class PhoneNumberFormatter: Formatter {
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) as AnyObject
        return true
    }
    
    override func string(for obj: Any?) -> String? {
        guard let phoneNumber = obj as? String else {return nil}
        guard phoneNumber.count == 10 else {return phoneNumber}
        
        return phoneNumber.replacingOccurrences(of: "([0-9]{3})([0-9]{3})([0-9]{1,4})?", with: "($1)-$2-$3", options: .regularExpression)
    }
    
//    func getNewPosition(forPosition: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
//        <#code#>
//    }
    
}
