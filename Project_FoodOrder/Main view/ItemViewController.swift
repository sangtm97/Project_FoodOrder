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
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "shoppingcart"), style: .plain, target: self, action: #selector(self.addToCartAction))]
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
    
    
    //MARK: IBACtions
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToCartAction(){
        
        //Check if user is logged in or show login view
        downloadCartFromFỉrestore("1234"){ (cart) in
            if cart == nil{
                self.createNewCart()
            }
            else{
                cart!.itemIds.append(self.item.id)
                self.updateCart(cart: cart!, withValue: [KITEMIDS: cart!.itemIds])
            }
        }
    }
    
    //MARK: Add to cart
    private func createNewCart(){
        let newCart = Cart()
        newCart.id = UUID().uuidString
        newCart.ownerId = "1234"
        newCart.itemIds = [self.item.id]
        saveCartToFirestore(newCart)
        
        self.hud.textLabel.text = "Added to cart!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateCart(cart: Cart, withValue: [String : Any]){
        updateCartInFirestore(cart, withValue: withValue){ (error) in
            if error != nil{
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                print("error updating basket", error!.localizedDescription)
            }
            else{
                self.hud.textLabel.text = "Added to cart!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
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
