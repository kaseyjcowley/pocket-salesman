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
    
    // TODO: Consolidate this to one?
    var filteredAccounts: [BaseAccount] = [BaseAccount]()
    var accounts: [BaseAccount] = [BaseAccount]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let current = filteredAccounts[indexPath.row]
        
        switch current {
            case is Account:
                let account = current as! Account
                let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualAccountCell") as! IndividualTableViewCell
                
                cell.accountName?.text = account.name
                cell.avatar = createAvatar(from: account.avatar)
                
                let (mActual, mGoal) = account.monthlySales
                
                cell.monthlyCircularProgressView?.color = getColor(forGoalProgress: mActual / mGoal)
                cell.monthlyCircularProgressView?.ratio = account.monthlySales
                cell.monthlyProgressTotals?.text = "$\(mActual.withCommas()) / $\(mGoal.withCommas())"
                
                let (aActual, aGoal) = account.annualSales
                
                cell.annualCircularProgressView?.color = getColor(forGoalProgress: aActual / aGoal)
                cell.annualCircularProgressView?.ratio = account.annualSales
                cell.annualProgressTotals?.text = "$\(aActual.withCommas()) / $\(aGoal.withCommas())"
                
                return cell
            
            case is Organization:
                let account = current as! Organization
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationAccountCell") as! OrganizationTableViewCell
                
                cell.customerName?.text = account.name
                cell.totalAccountsBadge?.text = String(account.accounts.count)
                cell.avatar = createAvatar(from: account.avatar)
                
                return cell

            default: break
        }
        
        // TODO: This should never happen. How can we tell if it did?
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let account = filteredAccounts[indexPath.row]
        
        switch account {
        case is Organization:
            return OrganizationTableViewCell.rowHeight
        case is Account:
            return IndividualTableViewCell.rowHeight
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    /** Set an avatar on a tableView cell */
    private func createAvatar(from data: Data?) -> UIImageView? {
        let avatar = UIImageView()
        
        if data != nil {
            avatar.image = UIImage(data: data!)
        } else {
            avatar.image = #imageLiteral(resourceName: "Avatar")
        }
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.bounds.size.height / 2
        
        return avatar
    }
    
    /** Get a color representing how well the account's sales progress is going */
    private func getColor(forGoalProgress progress: Double) -> UIColor {
        if progress >= 75 {
            return UIColor.Custom.success
        } else if progress > 25 && progress < 75 {
            return UIColor.Custom.warning
        } else {
            return UIColor.Custom.danger
        }
    }
    
    private func sortedAccounts(by criteria: SortableCriteria) -> [BaseAccount] {
        return filteredAccounts.sorted(by: { (a1, a2) in
            return a1.name < a2.name
        })
    }

}

// Extension to handle IBActions
extension AccountListTableViewController {
 
    @IBAction func addNewAccount(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Create an account", message: "What type of account?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Individual", style: .default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "addIndividualAccountVC", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Organization", style: .default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "addOrganizationAccountVC", sender: self)
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
            filteredAccounts = filteredAccounts.filter({account in
                return account.name.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredAccounts = sortedAccounts(by: .name)
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            filteredAccounts = sortedAccounts(by: .name)
        case 2:
//            filteredAccounts = filteredAccounts.sorted(by: {(account1, account2) in
//                let account1Progress = account1.annualSales.0 / account1.annualSales.1
//                let account2Progress = account2.annualSales.0 / account2.annualSales.1
//
//                return account1Progress > account2Progress
//            })
            break
        default:
            break
        }
        
        tableView.reloadData()
    }
    
}

extension AccountListTableViewController: ReceivesAccountDataDelegate {
    
    func receive(account: BaseAccount) {
        filteredAccounts.append(account)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredAccounts.count-1, section: 0)], with: .none)
        tableView.endUpdates()
        
        // TODO: Should this be put in a didSet?
        filteredAccounts = sortedAccounts(by: .name)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AddAccountViewController else {return}
        
        vc.delegate = self
        
        switch segue.identifier {
        case "addIndividualAccountVC":
            vc.accountType = .individual
        case "addOrganizationAccountVC":
            vc.accountType = .organization
        default: break // TODO: This should probably throw an error
        }
    }
    
}

protocol ReceivesAccountDataDelegate: class {
    func receive(account: BaseAccount)
}
