//
//  AddOrganizationViewController.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 8/29/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import Eureka
import FloatLabelRow

class OrganizationAccountFormViewController: FormViewController, HasForm {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        
        form +++
            Section("Account")
                <<< TextFloatLabelRow(FormTags.Account.name) {
                        $0.title = "Name"
                        $0.add(rule: RuleRequired())
                    }
    }
    
    private func defaultOnRowValidationChanged(cell: BaseCell, row: BaseRow) {
        let rowIndex = row.indexPath!.row
        
        setTextErrorState(cell, row.isValid)
        
        // Remove all validation messages
        while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
            _ = row.section?.remove(at: rowIndex + 1)
        }
        
        if !row.isValid {
            let error = row.validationErrors.first
            let labelRow = LabelRow() {
                $0.title = error?.msg
                $0.cell.height = { 40 }
                $0.cell.backgroundColor = .red
                }.cellUpdate({ (cell, _) in
                    cell.textLabel?.textColor = .white
                })
            
            row.section?.insert(labelRow, at: rowIndex + 1)
        }
    }
    
    private func setTextErrorState(_ cell: BaseCell, _ isRowValid: Bool) {
        let textColor: UIColor = isRowValid ? .black : .red
        
        switch (cell) {
        case is TextFloatLabelCell:
            (cell as? TextFloatLabelCell)?.textField.textColor = textColor
        default: break
        }
    }

}
