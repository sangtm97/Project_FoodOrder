//
//  FirebaseCollectionReference.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 17/05/2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Cart
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
