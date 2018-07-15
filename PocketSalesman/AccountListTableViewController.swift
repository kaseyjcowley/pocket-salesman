//
//  CustomerListTableTableViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 6/13/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit

class AccountListTableViewController: UITableViewController {
    
    var filteredCustomers: [Account] = [Account]()
    var accounts: [Account] = [
        Account(name: "Acme Corporation", contactName: "Joe Schmoe"),
        Account(name: "The Realty Group", contactName: "Sally Realtor", accountType: .Group),
        Account(name: "Stark Industries", contactName: "Tony Stark"),
        Account(name: "Wayne Enterprises", contactName: "Bruce Wayne")
    ]
    
    override func viewDidLoad() {
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        
        // TODO - Refactor this into something more sane
        switch account.accountType {
            case .Individual:
                let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualAccountCell") as! IndividualAccountTableViewCell
                cell.customerName?.text = account.name
                
                if let avatar = cell.avatar {
                    avatar.image = UIImage(named: "Avatar")
                    avatar.layer.masksToBounds = true
                    avatar.layer.cornerRadius = avatar.bounds.size.height / 2
                }
                
                cell.monthlyCircularProgressView?.color = UIColor.Custom.warning
                cell.monthlyCircularProgressView?.progress = 0.55
                cell.monthlyProgressTotals?.text = "\(550.withCommas()) / \(1000.withCommas())"
                
                cell.yearlyCircularProgressView?.color = UIColor.Custom.success
                cell.yearlyCircularProgressView?.progress = 1.0
                cell.yearlyProgressTotals?.text = "\(2000.withCommas()) / \(2000.withCommas())"
                
                return cell
            
            case .Group:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupAccountCell") as! GroupAccountTableViewCell
                cell.customerName?.text = account.name
                
                if let avatar = cell.avatar {
                    avatar.image = UIImage(named: "Avatar")
                    avatar.layer.masksToBounds = true
                    avatar.layer.cornerRadius = avatar.bounds.size.height / 2
                }
                
                return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let account = accounts[indexPath.row]
        
        return account.accountType == .Group
            ? GroupAccountTableViewCell.rowHeight
            : IndividualAccountTableViewCell.rowHeight
    }

}

// Extension to handle IBActions
extension AccountListTableViewController {
 
    // MARK: - IBActions
    @IBAction func addNewCustomer(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Create account", message: "What type of account?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Individual", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Organization", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
}
