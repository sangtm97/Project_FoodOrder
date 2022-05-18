//
//  CategoryCollectionViewCell.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category){
        nameLabel.text = category.name
        imageView.image = category.image
    }
}
