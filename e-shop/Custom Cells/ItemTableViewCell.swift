//
//  ItemTableViewCell.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 02.08.2024.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var pricelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(_ item: Item) {
        
        nameLabel.text = item.name
        descriptionlabel.text = item.description
        pricelabel.text = convertToCurrency(item.price ?? 0.00)
        pricelabel.adjustsFontSizeToFitWidth = true
        
        if item.imageLinks != nil && item.imageLinks.count > 0 {
            
            downloadImages(imageURLs: [item.imageLinks.first!]) { images in
                
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }

}
