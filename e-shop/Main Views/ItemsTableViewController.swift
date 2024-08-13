//
//  ItemsTableViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 29.07.2024.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var categoty: Category?
    var itemArray: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        self.title = categoty?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if categoty != nil {
            loadItems()
        }
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
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToAddItem" {
            
            let vc = segue.destination as! AddItemViewController
            vc.category = categoty!
        }
    }
    
    private func showItemView(_ item: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "itemView") as! ItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    private func loadItems() {
        
        downloadItemFromFirebase(withCategoryId: categoty!.id) { allItems in
            
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }

}
