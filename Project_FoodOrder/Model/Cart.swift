//
//  Cart.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import Foundation

class  Cart {
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[KOBJECTID] as? String
        ownerId = _dictionary[KOWNERID] as? String
        itemIds = _dictionary[KITEMIDS] as? [String]
    }
}

//MARK: Download cart
func downloadCartFromFỉrestore(_ ownerId: String, completion: @escaping (_ cart: Cart?) -> Void){
    FirebaseReference(.Cart).whereField(KOWNERID, isEqualTo: ownerId).getDocuments {(snapshot, error) in
        guard let snapshot = snapshot else{
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0{
            let cart = Cart(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(cart)
        }
        else{
            completion(nil)
        }
    }
}

//MARK: Save to Firebase
func saveCartToFirestore(_ cart: Cart){
    FirebaseReference(.Cart).document(cart.id).setData(cartDictionaryFrom(cart) as! [String: Any])
}

//MARK: Helpers
func cartDictionaryFrom(_ cart: Cart) -> NSDictionary{
    return NSDictionary(objects: [cart.id, cart.ownerId, cart.itemIds], forKeys: [KOBJECTID as NSCopying, KOWNERID as NSCopying, KITEMIDS as NSCopying])
}

//MARK: Update basket
func updateCartInFirestore(_ cart: Cart, withValue: [String: Any], completion: @escaping (_ error: Error?) -> Void){
    FirebaseReference(.Cart).document(cart.id).updateData(withValue) {(error) in
        completion(error)
    }
}

