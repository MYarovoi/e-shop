//
//  AddItemViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 30.07.2024.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pricetextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var category: Category!
    
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
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
        
        itemImages = []
        showImageGallery()
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
    
    private func showImageGallery () {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true)
    }
}

//MARK: - GalleryControllerDelegate
extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolveImages) in
                
                self.itemImages = resolveImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}
