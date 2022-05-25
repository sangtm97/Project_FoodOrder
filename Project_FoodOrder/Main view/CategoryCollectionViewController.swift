//
//  CategoryCollectionViewController.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UICollectionViewController {

    //MARK: Vars
        var categoryArray: [Category] = []
        
        private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemPerRow: CGFloat = 3.5
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createCategorySet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            loadCategories()
        }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        cell.generateCell(categoryArray[indexPath.row])
        cell.layer.cornerRadius = 20.0
        return cell
    }
    
    //MARK: UICollectView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItemSeg", sender: categoryArray[indexPath.row])
    }
    
    //MARK: Download categories
    private func loadCategories(){
        downloadCategoryFronFirebase{ (allCategories) in
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryToItemSeg" {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
        }
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let titleCategoryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoriesCollectionReusableView", for: indexPath) as? CategoriesCollectionReusableView {
                titleCategoryView.titleLabel.text = "Categories"
                return titleCategoryView
            }
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
}
