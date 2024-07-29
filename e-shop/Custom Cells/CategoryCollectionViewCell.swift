//
//  CategoryCollectionViewCell.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 26.07.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category) {
        
        nameLabel.text = category.name
        imageView.image = category.image
    }
}
