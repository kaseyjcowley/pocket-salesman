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
    var accounts: [Account] = [Account]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredAccounts = accounts.sorted(by: {$0.contact.name < $1.contact.name})
        
        // Setup search controller to filter results
        searchController.apply {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = "Search Accounts"
            $0.searchBar.delegate = self
            $0.searchBar.scopeButtonTitles = ["Name", "Volume", "Goal"]
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
        switch account.type {
            case .individual:
                let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualAccountCell") as! IndividualAccountTableViewCell
                cell.customerName?.text = account.name
                
                if let avatar = cell.avatar {
                    if let image = account.avatar {
                        avatar.image = UIImage(data: image)
                    } else {
                        avatar.image = UIImage(named: "Avatar")
                    }
                    
                    avatar.layer.masksToBounds = true
                    avatar.layer.cornerRadius = avatar.bounds.size.height / 2
                }
                
                cell.monthlyCircularProgressView?.color = UIColor.Custom.warning
                cell.monthlyCircularProgressView?.ratio = account.monthlySales
                
                // TODO - Make this easier to format
                let (mActual, mGoal) = account.monthlySales
                cell.monthlyProgressTotals?.text = "$\(mActual.withCommas()) / $\(mGoal.withCommas())"
                
                cell.annualCircularProgressView?.color = UIColor.Custom.success
                cell.annualCircularProgressView?.ratio = account.annualSales
                
                // TODO - Make this easier to format
                let (aActual, aGoal) = account.annualSales
                cell.annualProgressTotals?.text = "$\(aActual.withCommas()) / $\(aGoal.withCommas())"
                
                return cell
            
            case .group:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupAccountCell") as! GroupAccountTableViewCell
                
                cell.customerName?.text = account.name
//                cell.groupCountBadge?.text = String(account.numberOfAccounts)
                
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
        
        switch account.type {
        case .group:
            return GroupAccountTableViewCell.rowHeight
        case .individual:
            return IndividualAccountTableViewCell.rowHeight
        }
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
extension AccountListTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if !searchText.isEmpty {
            filteredAccounts = accounts.filter({account in
                return account.contact.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredAccounts = accounts.sorted(by: {$0.contact.name < $1.contact.name})
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            filteredAccounts = filteredAccounts.sorted(by: {$0.contact.name < $1.contact.name})
        case 2:
            filteredAccounts = filteredAccounts.sorted(by: {(account1, account2) in
                let account1Progress = account1.annualSales.0 / account1.annualSales.1
                let account2Progress = account2.annualSales.0 / account2.annualSales.1
            
                return account1Progress > account2Progress
            })
        default:
            break
        }
        
        tableView.reloadData()
    }
    
}

extension AccountListTableViewController: ReceivesAccountDataDelegate {
    
    func receive(account: Account) {
        filteredAccounts.append(account)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredAccounts.count-1, section: 0)], with: .none)
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addIndividualAccountVC" {
            if let vc = segue.destination as? AddAccountViewController {
                vc.delegate = self
            }
        }
    }
    
}

protocol ReceivesAccountDataDelegate: class {
    func receive(account: Account)
}
