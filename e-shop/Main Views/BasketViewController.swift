//
//  BasketViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 12.08.2024.
//

import UIKit

class BasketViewController: UIViewController {
    
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var basketTotalpriceLabel: UILabel!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButton: UIButton!
    
    var basket: Basket?
    var allItems: [Item] = []
    var purchesedItemIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBasketFromFirestore()
    }
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - Download basket
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore("1234") { basket in
            
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            
            downloadItems(basket!.itemIds) { itemArray in
                
                self.allItems = itemArray
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            
            totalItems.text = "0"
            basketTotalpriceLabel.text = returnBasketTotalPrice()
        } else {
            
            totalItems.text = "\(allItems.count)"
            basketTotalpriceLabel.text = returnBasketTotalPrice()
        }
    }
    
    private func returnBasketTotalPrice() -> String {
        
        var totalPrice: Double = 0
        
        for item in allItems {
            
            totalPrice += item.price
        }
        
        return "Total price: " + convertToCurrency(totalPrice)
    }
    
    
}
