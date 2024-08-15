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
    var editBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
        checkOnBoardingStatus()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    private func checkOnBoardingStatus() {
        
        if MUser.currentUser() != nil {
            
            if MUser.currentUser()!.onBoard {
                
                finishRegistrationButton.setTitle("Account is active", for: .normal)
                finishRegistrationButton.isEnabled = false
            } else {
                
                finishRegistrationButton.setTitle("Finish registration", for: .normal)
                finishRegistrationButton.isEnabled = true
                finishRegistrationButton.tintColor = .red
            }
        } else {
            finishRegistrationButton.setTitle("Logged out", for: .normal)
            finishRegistrationButton.isEnabled = false
            purchaseHistoryButton.isEnabled = false
        }
    }
    
    private func checkLoginStatus() {
        
        if MUser.currentUser() == nil {
            
            createBarButtonWith(title: "Login")
        } else {
            createBarButtonWith(title: "Edit")
        }
    }
    
    private func createBarButtonWith(title: String) {
        
        editBarButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        self.navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc func rightBarButtonPressed() {
        
        if editBarButton.title == "Login" {
            
            showLoginView()
        } else {
            
            goToEditProfile()
        }
    }
    
    private func showLoginView() {
        
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true)
    }
    
    private func goToEditProfile() {
        
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
}
