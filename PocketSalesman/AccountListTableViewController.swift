//
//  CustomerListTableTableViewController.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 6/13/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import Foundation
import UIKit

class AccountListTableViewController: UITableViewController {
    
    var filteredAccounts: [Account] = [Account]()
    var accounts: [Account] = [
        Account(name: "Acme Corporation", contactName: "Joe Schmoe"),
        Account(name: "The Realty Group", contactName: "Sally Realtor", accountType: .Group),
        Account(name: "Stark Industries", contactName: "Tony Stark"),
        Account(name: "Wayne Enterprises", contactName: "Bruce Wayne")
    ]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredAccounts = accounts
        
        // Setup search controller to filter results
        searchController.apply {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "Search Accounts"
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAccounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = filteredAccounts[indexPath.row]
        
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
                // TODO - Make this easier to format
                cell.monthlyProgressTotals?.text = "$\(550.withCommas()) / $\(1000.withCommas())"
                
                cell.annualCircularProgressView?.color = UIColor.Custom.success
                cell.annualCircularProgressView?.progress = 1.0
                // TODO - Make this easier to format
                cell.annualProgressTotals?.text = "$\(2000.withCommas()) / $\(2000.withCommas())"
                
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
        let account = filteredAccounts[indexPath.row]
        
        return account.accountType == .Group
            ? GroupAccountTableViewCell.rowHeight
            : IndividualAccountTableViewCell.rowHeight
    }

}

// Extension to handle IBActions
extension AccountListTableViewController {
 
    // MARK: - IBActions
    @IBAction func addNewCustomer(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Create an account", message: "What type of account?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Individual", style: .default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "addIndividualAccountVC", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Organization", style: .default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "addGroupAccountVC", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
    }
    
}

// Extension to handle updating search results when filtering
extension AccountListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if !searchText.isEmpty {
            filteredAccounts = accounts.filter({account in
                return account.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredAccounts = accounts
        }
        
        tableView.reloadData()
    }
    
}
