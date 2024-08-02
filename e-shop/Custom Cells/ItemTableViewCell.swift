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
        pricelabel.text = String(item.price ?? 0.00) 
        
    }

}
