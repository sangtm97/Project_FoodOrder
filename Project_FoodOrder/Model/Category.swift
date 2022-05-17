//
//  Category.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import Foundation
import UIKit

class Category{
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String){
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[KOBJECTID] as! String
        name = _dictionary[KNAME] as! String
        image = UIImage(named: _dictionary[KIMAGENAME] as? String ?? "")
    }
}

//MARK: Download category from firebase
func downloadCategoryFronFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void){
    var categoryArray: [Category] = []
    FirebaseReference(.Category).getDocuments{ (snapshot, error) in
        guard let snapshot = snapshot else{
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty{
            for categoryDic in snapshot.documents{
                print("Created new category with")
                categoryArray.append(Category(_dictionary: categoryDic.data() as NSDictionary))
            }
            
            
        }
        completion(categoryArray)
    }
}

//MARK: save category
func saveCategoryToFireBase(_ category: Category){
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String: Any])
}

//MARK: Helpers
func categoryDictionaryFrom(_ category: Category) -> NSDictionary{
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [KOBJECTID as NSCopying, KNAME as NSCopying, KIMAGENAME as NSCopying])
}

//use only time
func createCategorySet(){
    let pizza = Category(_name: "Pizza", _imageName: "pizza")
    let buger = Category(_name: "Burger", _imageName: "burger")
    let drink = Category(_name: "Pepsi", _imageName: "pepsi")
    let desert = Category(_name: "Desert", _imageName: "desert")
    
    let arrCategories = [pizza, buger, drink, desert]
    for category in arrCategories{
        saveCategoryToFireBase(category)
    }
}
