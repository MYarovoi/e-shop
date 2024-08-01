//
//  AddItemViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 30.07.2024.
//

import UIKit
import Photos
import PhotosUI

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pricetextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var category: Category!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray

        return indicator
    }()
    
    var itemImages: [UIImage?] = []
    var imagePicker =  UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        
        dismissKeayboard()
        
        if fieldsAreCompleted() {
            
            saveToFirebase()
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        itemImages = []
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
        
        activityIndicator.startAnimating()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text
        item.categotyId = category.id
        item.description = descriptionTextView.text
        item.price = Double(pricetextField.text!)
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { imageLinks in
                
                item.imageLinks = imageLinks
                
                saveItemToFirebase(item)
                self.popTheView()
                
                self.activityIndicator.stopAnimating()
            }
        } else {
            
            saveItemToFirebase(item)
            popTheView()
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 6
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                       
                        DispatchQueue.main.async {
                            self.itemImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

extension AddItemViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
        
            DispatchQueue.main.async {
                self.itemImages.append(image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
