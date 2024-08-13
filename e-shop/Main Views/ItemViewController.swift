//
//  ItemViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 06.08.2024.
//

import UIKit

class ItemViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var item: Item!
    var itemsImages: [UIImage] = []
    private let sectionsInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let itemsPerRows: CGFloat = 1
    private let cellHight: CGFloat = 196.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        downloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(
                image: UIImage(named: "back"),
                style: .plain,
                target: self,
                action: #selector(self.backAction)
            )]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(
                image: UIImage(named: "addToBasket"),
                style: .plain,
                target: self,
                action: #selector(self.addToBasketPressed)
            )]
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        if item != nil {
            
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price ?? 0.00)
            descriptionTextView.text = item.description
        }
    }
    
    @objc func backAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasketPressed() {
        
        downloadBasketFromFirestore("1234") { basket in
            
            if basket == nil {
                
                self.createNewBasket()
            } else {
                
                basket!.itemIds.append(self.item.id)
                self.updateBasket(basket!, withValues: [kITEMIDS : basket!.itemIds])
            }
        }
    }
    
    //MARK: - Add to basket
    
    private func createNewBasket() {
        
        let newBasket = Basket()
        newBasket.id = UUID().uuidString
        newBasket.ownerId = "1234"
        newBasket.itemIds = [self.item.id]
        saveBasketToFirestore(newBasket)
    }
    
    private func updateBasket(_ basket: Basket, withValues: [String : Any]) {
        
        updateBasketInFirestore(basket, withvalues: withValues) { error in
            
            if error != nil {
                
                self.showPopupMessage(message: "Error: \(error!.localizedDescription)")
                debugPrint(error!)
            } else {
                
                self.showPopupMessage(message: "Added to basket")
            }
        }
    }
    
    //MARK: - Show Popup Message
    func showPopupMessage(message: String) {
        
        //Add Image 
    
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Download Pictures
    
    private func downloadPictures() {
        
        if item != nil && item.imageLinks != nil {
            
            downloadImages(imageURLs: item.imageLinks) { allImages in
                
                if allImages.count > 0 {
                    self.itemsImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemsImages.count == 0 ? 1 : itemsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemsImages.count > 0 {
        
            cell.setupImageWith(itemImage: itemsImages[indexPath.row])

        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availiableWidth = collectionView.frame.width - sectionsInset.left
        
        return CGSize(width: availiableWidth, height: cellHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        return sectionsInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionsInset.left
    }
}
