//
//  ItemTableViewCell.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 22/05/2022.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func genrateCell(_ item: Item){
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertTocurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        
        if item.imageLinks != nil && item.imageLinks.count > 0{
            downloadImage(imageUrls: [item.imageLinks.first!]) {
                (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }

}
