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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray

        return indicator
    }()
    
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
        
        if textFieldsHaveText() {
            
            registerUser()
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        
        
    }
    
    //MARK: - Register User
    private func registerUser() {
        
        addActivityIndicator()
        activityIndicator.startAnimating()
        
        MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
            
            if error == nil {
                
                let alertController = UIAlertController(title: "Success", message: "Varification email has been sent", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alertController.dismiss(animated: true)
                }
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: "Error: \(error!.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                        alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                debugPrint("Error \(error!.localizedDescription)")
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func dismissView() {
        
        self.dismiss(animated: true)
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return (emailTextField.text != "" && passwordTextField.text != "")
    }   
    
    private func addActivityIndicator() {
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
