//
//  Item.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 18/05/2022.
//

import Foundation
import UIKit

class Item{
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    init(){
        
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[KOBJECTID] as? String
        categoryId = _dictionary[KCATEGORYID] as? String
        name = _dictionary[KNAME] as? String
        description = _dictionary[KDESCRIPTION] as? String
        price = _dictionary[KPRICE] as? Double
        imageLinks = _dictionary[KIMAGELINKS] as? [String]
    }
}

//MARK: Save items func
func saveItemToFirestore(_ item: Item){
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}

//MARK: Helpers functions
func itemDictionaryFrom(_ item: Item) -> NSDictionary{
    return NSDictionary(objects: [item.id, item.categoryId, item.name, item.description, item.price, item.imageLinks], forKeys: [KOBJECTID as NSCopying, KCATEGORYID as NSCopying, KNAME as NSCopying, KDESCRIPTION as NSCopying, KPRICE as NSCopying, KIMAGELINKS as NSCopying] )
}


//MaRK: Download func
func downloadItemsFromFirebase(_ WithCategoryId: String, completion: @escaping(_ itemArray: [Item]) -> Void){
    var itemArray: [Item] = []
    FirebaseReference(.Items).whereField(KCATEGORYID, isEqualTo: WithCategoryId).getDocuments{ (snapshot, error) in
        guard let snapshot = snapshot else{
            completion(itemArray)
            return
        }
        if !snapshot.isEmpty{
            for itemDict in snapshot.documents{
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
}
