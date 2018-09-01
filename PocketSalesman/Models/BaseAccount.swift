//
//  BaseAccount.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 8/31/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation

protocol BaseAccount {
    var avatar: Data? {get set}
    var name: String {get set}
}
