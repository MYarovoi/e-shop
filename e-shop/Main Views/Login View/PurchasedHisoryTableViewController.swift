//
//  PurchasedHisoryTableViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 16.08.2024.
//

import UIKit

class PurchasedHisoryTableViewController: UITableViewController {
    
    var itemArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        return cell
    }
    
    //MARK: - Load items
    
    private func loadItems() {
        
        downloadItems(MUser.currentUser()!.purchasedItemIds) { itemArray in
            
            self.itemArray = itemArray
            self.tableView.reloadData()
        }
    }
}
