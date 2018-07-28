//
//  ContactFormViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/27/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import Eureka

class ContactFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var section = Section()
        
        form += [section]
        
        section += [
            NameRow() {$0.placeholder = "Name"},
            PhoneRow() {$0.placeholder = "Phone"},
            PhoneRow() {$0.placeholder = "Fax"},
            EmailRow() {$0.placeholder = "Email"},
            TextRow() {$0.placeholder = "Address"},
            TextRow() {$0.placeholder = "City"},
            TextRow() {$0.placeholder = "State"},
            ZipCodeRow() {$0.placeholder = "Zip Code"},
            TextAreaRow() {$0.placeholder = "Notes"}
        ]
    }

}
