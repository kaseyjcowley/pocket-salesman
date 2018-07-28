//
//  Customer.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 6/14/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation

enum AccountType: String {
    case individual
    case group
    
    func toString() -> String {
        return self.rawValue
    }
}

class Account {
    var contact: Contact
    var supervisor: Supervisor
    
    struct Contact {
        var name: String
        var phone: String
        var fax: String
        var email: String
        var address: String
        var city: String
        var state: String
        var zip: String
        var notes: String
    }
    
    struct Supervisor {
        var name: String
        var phone: String
        var email:   String
    }
    
    var monthlySales: (Double, Double) = (0.0, 0.0)
    var annualSales: (Double, Double) = (0.0, 0.0)
    
//    var numberOfAccounts: Int = 0
    
    var type: AccountType = .individual
    
    init(contact: Contact, supervisor: Supervisor, monthlySales: (Double, Double), annualSales: (Double, Double)) {
        self.contact = contact
        self.supervisor = supervisor
        self.monthlySales = monthlySales
        self.annualSales = annualSales
    }
    
//    init(name: String, numberOfAccounts: Int) {
//        self.name = name
//        self.numberOfAccounts = numberOfAccounts
//        self.type = .group
//    }
}
