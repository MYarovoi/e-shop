//
//  SearchViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 19.08.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    var searchResults: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func searchBarButtonPressed(_ sender: UIBarButtonItem) {
        
        dismissKeyboard()
        showSearchField()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        
    }
    
    //MARK: - Helpers
    
    private func emptyTextField() {
        
        searchTextField.text = ""
    }
    
    private func dismissKeyboard() {
        
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChanged (_ textField: UITextField) {
        
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled {
            
            searchButtonOutlet
        } else {
            
            disableSearchButton()
        }
    }
    
    private func disableSearchButton() {
        
        searchButtonOutlet.isEnabled = false
    }
    
    private func showSearchField() {
        
        disableSearchButton()
        emptyTextField()
        animateSearchOptionIn()
    }
    
    private func animateSearchOptionIn() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
    }
    
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemView") as! ItemViewController
        
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemView(withItem: searchResults[indexPath.row])
    }
}
