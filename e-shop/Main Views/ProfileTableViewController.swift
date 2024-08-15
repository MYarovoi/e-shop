//
//  ProfileTableViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 15.08.2024.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var finishRegistrationButton: UIButton!
    @IBOutlet weak var purchaseHistoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
