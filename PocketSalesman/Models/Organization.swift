//
//  Organization.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 8/28/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation

struct Organization: BaseAccount {
    var avatar: Data?
    var name: String
    var accounts: [Account] = [Account]()
    
    init(values: [String:Any?]) {
        self.avatar = values["avatar"] as? Data
        self.name = values["account.name"] as! String
        self.accounts = []
    }
    
    init(avatar: Data?, name: String, accounts: [Account]) {
        self.avatar = avatar
        self.name = name
        self.accounts = accounts
    }
}
