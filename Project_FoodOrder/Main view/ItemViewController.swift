//
//  ItemViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 22/05/2022.
//

import UIKit
import JGProgressHUD
class ItemViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: Vars
    var item: Item!
    var itemImage: [UIImage] = []
    var hud = JGProgressHUD(style:  .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPicture()
    }
    
    //MARK: Download image
    private func downloadPicture(){
        if item != nil && item.imageLinks != nil{
            downloadImage(imageUrls: item.imageLinks){(allimage) in
                if allimage.count > 0{
                    self.itemImage = allimage as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: Setou UI
    private func setupUI(){
        if item != nil{
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertTocurrency(item.price)
            descriptionTextView.text = item.description
        }
    }

}

extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImage.count == 0 ? 1 : itemImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        if itemImage.count > 0{
            cell.setupImageWith(itemImage: itemImage[indexPath.row])
        }
      
        return cell
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left
        print(availableWidth)
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
