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
    var avatar: Data?
    var name: String
    var notes: String?
    
    var contact: Contact
    var supervisor: Supervisor
    
    struct Contact {
        var name: String
        var phone: String
        var fax: String?
        var email: String
        var address: String
        var city: String
        var state: String
        var zip: String
        
        init(values: [String:String]) {
            self.name    = values["name"]!
            self.phone   = values["phone"]!
            self.fax     = values["fax"]
            self.email   = values["email"]!
            self.address = values["address"]!
            self.city    = values["city"]!
            self.state   = values["state"]!
            self.zip     = values["zip"]!
        }
    }
    
    struct Supervisor {
        var name: String?
        var phone: String?
        var email: String?
        
        init(values: [String:String]) {
            self.name  = values["name"]
            self.phone = values["phone"]
            self.email = values["email"]
        }
    }
    
    var monthlySales: (Double, Double) = (0.0, 0.0)
    var annualSales: (Double, Double) = (0.0, 0.0)
    
//    var numberOfAccounts: Int = 0
    
    var type: AccountType = .individual
    
    init(avatar: Data?, name: String, contact: Contact, supervisor: Supervisor, notes: String, monthlySales: (Double, Double), annualSales: (Double, Double)) {
        self.avatar = avatar
        self.name = name
        self.contact = contact
        self.supervisor = supervisor
        self.notes = notes
        self.monthlySales = monthlySales
        self.annualSales = annualSales
    }
}
