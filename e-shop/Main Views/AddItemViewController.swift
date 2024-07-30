//
//  AddItemViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 30.07.2024.
//

import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pricetextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var category: Category!
    var itemImages: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            
            saveToFirebase()
        } else {
            
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        dismissKeayboard()
    }
    
    private func dismissKeayboard() {
        
        self.view.endEditing(false)
    }
    
    private func fieldsAreCompleted() -> Bool {
        
        return (titleTextField.text != "" && pricetextField.text != "" && descriptionTextView.text != "")
    }
    
    private func popTheView () {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func saveToFirebase () {
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text
        item.categotyId = category.id
        item.description = descriptionTextView.text
        item.price = Double(pricetextField.text!)
        
        if itemImages.count > 0 {
            
            
        } else {
            
            saveItemToFirebase(item)
            popTheView()
        }
    }
}
