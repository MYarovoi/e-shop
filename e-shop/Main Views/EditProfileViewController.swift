//
//  EditProfileViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 15.08.2024.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        dismissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surnameTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!), kFULLADDRESS : addressTextField.text!]
            
            updateCurrenUserInFirestore(withValues: withValues) { error in
                
                if error == nil {
                    
                    let alertController = UIAlertController(title: "Success", message: "Updated!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                            alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                } else {
                    
                    debugPrint("Error updating user: \(error!.localizedDescription)")
                    
                    let alertController = UIAlertController(title: "Error", message: "Error: \(error!.localizedDescription)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                            alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - Update UI
    
    private func loadUserInfo() {
        
        if MUser.currentUser() != nil {
            
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
        }
    }
    
    private func dismissKeyboard() {
        
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return (nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "")
    }
}
