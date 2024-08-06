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

    }
}
