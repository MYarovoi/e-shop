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
        
        if MUser.currentUser() != nil {
            
            loadBasketFromFirestore()
        } else {
            
            self.updateTotalLabels(true)
        }
    }
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - Download basket
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore(MUser.currentId()) { basket in
            
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
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            
            totalItems.text = "0"
            basketTotalpriceLabel.text = returnBasketTotalPrice()
        } else {
            
            totalItems.text = "\(allItems.count)"
            basketTotalpriceLabel.text = returnBasketTotalPrice()
        }
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketTotalPrice() -> String {
        
        var totalPrice: Double = 0
        
        for item in allItems {
            
            totalPrice += item.price
        }
        
        return "Total price: " + convertToCurrency(totalPrice)
    }
    
    //MARK: - Navigation
    
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "itemView") as! ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: - Control Checkout Button
    
    private func checkoutButtonStatusUpdate() {
        
        checkOutButton.isEnabled = allItems.count > 0
        
        if checkOutButton.isEnabled {
            
            checkOutButton.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        } else {
            
            disableCkeckoutButton()
        }
    }
    
    private func disableCkeckoutButton() {
        
        checkOutButton.isEnabled = false
        checkOutButton.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    private func removeItemFromBasket(itemID: String) {
        
        for i in 0 ..< basket!.itemIds.count {
            
            if itemID == basket!.itemIds[i] {
                
                basket!.itemIds.remove(at: i)
                
                return
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
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemID: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withvalues: [kITEMIDS : basket!.itemIds!]) { error in
                
                if error != nil {
                    
                    debugPrint("Erroro: \(error!.localizedDescription)")
                }
                
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showItemView(withItem: allItems[indexPath.row])
    }
}
