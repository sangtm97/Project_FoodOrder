//
//  ImageCollectionViewCell.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 22/05/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage){
        imageView.image = itemImage
    }
}
