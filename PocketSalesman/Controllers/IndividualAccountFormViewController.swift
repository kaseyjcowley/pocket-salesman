//
//  ContactFormViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/27/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import Eureka
import FloatLabelRow

struct FormTags {
    enum TagType: String {
        case account
        case contact
        case supervisor
        case misc
    }
    
    struct Account {
        static let name = "\(TagType.account).name"
    }
    
    struct Contact {
        static let name = "\(TagType.contact).name"
        static let phone = "\(TagType.contact).phone"
        static let fax = "\(TagType.contact).fax"
        static let email = "\(TagType.contact).email"
        static let address = "\(TagType.contact).address"
        static let city = "\(TagType.contact).city"
        static let state = "\(TagType.contact).state"
        static let zip = "\(TagType.contact).zip"
    }
    
    struct Supervisor {
        static let name = "\(TagType.supervisor).name"
        static let phone = "\(TagType.supervisor).phone"
        static let email = "\(TagType.supervisor).email"
    }
    
    struct Miscellaneous {
        static let monthlyGoal = "\(TagType.misc).monthlyGoal"
        static let annualGoal = "\(TagType.misc).annualGoal"
        static let notes = "\(TagType.misc).notes"
    }
}

class IndividualAccountFormViewController: FormViewController, HasForm {
    
    lazy var emailCompletionSuggestionsView = EmailCompletionSuggestionsView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: self.navigationAccessoryView.bounds.size))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form += [accountSection(), contactSection(), supervisorSection(), miscSection()]
        
        TextFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        PhoneFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        EmailFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        ZipCodeFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        DecimalFloatLabelRow.defaultOnRowValidationChanged = self.defaultOnRowValidationChanged
        
        EmailFloatLabelRow.defaultOnCellHighlightChanged = { (cell, row) in
            if row.isHighlighted {
                self.navigationAccessoryView.addSubview(
                    self.emailCompletionSuggestionsView
                )
                
                self.emailCompletionSuggestionsView.setSuggestionSelectedHandler { [weak self] (suggestion) in
                    self?.completeEmail(with: suggestion, for: row)
                }
            } else {
                self.emailCompletionSuggestionsView.removeFromSuperview()
            }
        }
        
        PhoneFloatLabelRow.defaultCellSetup = { (cell, row) in
            cell.textField.addTarget(self, action: #selector(self.stripNonNumericCharacters), for: .editingChanged)
            row.useFormatterDuringInput = true
            row.formatter = PhoneNumberFormatter()
        }
    }
    
    // MARK: Sections
    private func accountSection() -> Section {
        var section = Section("Account")
        
        section += [
            TextFloatLabelRow(FormTags.Account.name, {
                $0.title = "Name*"
                $0.add(rule: RuleRequired())
            })
        ]
        
        return section
    }
    
    private func contactSection() -> Section {
        var section = Section("Contact")
        
        section += [
            TextFloatLabelRow(FormTags.Contact.name, {
                $0.title = "Name*"
            }),
            
            PhoneFloatLabelRow(FormTags.Contact.phone, {
                $0.title = "Phone*"
                $0.add(rule: RuleExactLength(exactLength: 10, msg: "Phone numbers must be 10 digits long", id: nil))
            }),
            
            PhoneFloatLabelRow(FormTags.Contact.fax, {
                $0.title = "Fax"
            }).onChange(self.maybeAddExactLengthRule),
            
            EmailFloatLabelRow(FormTags.Contact.email, {
                $0.title = "Email*"
                $0.add(rule: RuleEmail())
            }).onChange({ (row) in
                if let value = row.value {
                    self.emailCompletionSuggestionsView.showSuggestions(for: value)
                } else {
                    self.emailCompletionSuggestionsView.isHidden = true
                }
            }),
            
            TextFloatLabelRow(FormTags.Contact.address, {
                $0.title = "Address*"
            }),
            
            TextFloatLabelRow(FormTags.Contact.city, {
                $0.title = "City*"
            }),
            
            PickerInlineRow<String>(FormTags.Contact.state, {
                $0.title = "State*"
                $0.options = ["AZ", "CA", "UT"]
            }),
            
            ZipCodeFloatLabelRow(FormTags.Contact.zip, {
                $0.title = "Zip Code*"
            }),
        ]
        
        section.forEach { (row) in
            if row.title?.last == "*" {
                (row as? RowOf<String>)?.add(rule: RuleRequired())
            }
        }
        
        return section
    }
    
    private func supervisorSection() -> Section {
        var section = Section("Supervisor")
        
        section += [
            TextFloatLabelRow(FormTags.Supervisor.name, {
                $0.title = "Name"
            }),
            
            PhoneFloatLabelRow(FormTags.Supervisor.phone, {
                $0.title = "Phone"
            }).onChange(self.maybeAddExactLengthRule),
            
            EmailFloatLabelRow(FormTags.Supervisor.email, {
                $0.title = "Email"
                $0.add(rule: RuleEmail())
            }).onChange({ (row) in
                if let value = row.value {
                    self.emailCompletionSuggestionsView.showSuggestions(for: value)
                } else {
                    self.emailCompletionSuggestionsView.isHidden = true
                }
            }),
        ]
        
        return section
    }
    
    private func miscSection() -> Section {
        var section = Section("Miscellaneous")
        
        let formatter = CurrencyFormatter()
        formatter.locale = NSLocale.current
        formatter.numberStyle = NumberFormatter.Style.currency
        
        section += [
            DecimalFloatLabelRow(FormTags.Miscellaneous.monthlyGoal, {
                $0.useFormatterDuringInput = true
                $0.title = "Monthly Sales Goal*"
                $0.formatter = formatter
                $0.add(rule: RuleRequired())
            }),
            
            DecimalFloatLabelRow(FormTags.Miscellaneous.annualGoal, {
                $0.useFormatterDuringInput = true
                $0.title = "Annual Sales Goal*"
                $0.formatter = formatter
                $0.add(rule: RuleRequired())
            }),
            
            TextAreaRow(FormTags.Miscellaneous.notes, {
                $0.placeholder = "Notes"
            })
        ]
        
        return section
    }
    
    // MARK: Helpers
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
    
    private func maybeAddExactLengthRule(row: PhoneFloatLabelRow) {
        row.removeAllRules()
        
        if !row.value!.isEmpty {
            row.add(rule: RuleExactLength(exactLength: 10, msg: "Phone numbers must be 10 digits long", id: nil))
        }
    }
    
    private func setTextErrorState(_ cell: BaseCell, _ isRowValid: Bool) {
        let textColor: UIColor = isRowValid ? .black : .red
        
        switch (cell) {
        case is TextFloatLabelCell:
            (cell as? TextFloatLabelCell)?.textField.textColor = textColor
        case is EmailFloatLabelCell:
            (cell as? EmailFloatLabelCell)?.textField.textColor = textColor
        default: break
        }
    }
    
    @objc private func stripNonNumericCharacters(textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    private func completeEmail(with suggestion: String, for row: EmailFloatLabelRow) {
        if let currentValue: String = row.value {
            row.cell.textField.text = currentValue + suggestion
        }
    }

}

// MARK: Public API
//public func formValues(forTagType tagType: FormTags.TagType) -> [String:Any?] {
//    return form.values()
//        .filter({$0.key.starts(with: tagType.rawValue)})
//        .map(transform: {($0.replacingOccurrences(of: "\(tagType.rawValue).", with: ""), $1)})
//}
