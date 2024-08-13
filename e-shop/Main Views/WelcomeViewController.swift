//
//  WelcomeViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 13.08.2024.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        dismissView()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        
        
    }
    
    private func dismissView() {
        
        self.dismiss(animated: true)
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return (emailTextField.text != "" && passwordTextField.text != "")
    }    
}
