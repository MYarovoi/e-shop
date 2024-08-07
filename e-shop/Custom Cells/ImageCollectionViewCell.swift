//
//  ImageCollectionViewCell.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 07.08.2024.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
}
