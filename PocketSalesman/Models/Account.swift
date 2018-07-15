//
//  Customer.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 6/14/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation

enum AccountType: String {
    case Individual
    case Group
    
    func toString() -> String {
        return self.rawValue
    }
}

class Account {
    var name: String
    var contactName: String?
    var accountType: AccountType = .Individual
    
    init(name: String, contactName: String, accountType: AccountType = .Individual) {
        self.name = name
        self.contactName = contactName
        self.accountType = accountType
    }
}
