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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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
}

extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return UICollectionViewCell()
    }
    
    
    
}
