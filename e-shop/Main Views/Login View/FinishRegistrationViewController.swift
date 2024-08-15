//
//  FinishRegistrationViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 15.08.2024.
//

import UIKit

class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var DoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonePressed(_ sender: UIButton) {
        
        finishOnboarding()
        self.dismiss(animated: true)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        updateDoneButtonStatus()
    }
    
    private func updateDoneButtonStatus() {
        
        if nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "" {
            
            DoneButton.isEnabled = true
        } else {
            DoneButton.isEnabled = false
        }
    }
    
    private func finishOnboarding() {
        
        let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surnameTextField.text!, kONBOARD : true, kFULLADDRESS : addressTextField.text!, kFULLNAME: (nameTextField.text! + " " + surnameTextField.text!)] as [String : Any]
        
        updateCurrenUserInFirestore(withValues: withValues) { error in
            
            if error == nil {
                
                let alert  = UIAlertController(title: "Success", message: "Updated!", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alert.dismiss(animated: true)
                }
                                
            } else {
                
                debugPrint("Error updating User: \(error!.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message: "Error: \(error!.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                        alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
