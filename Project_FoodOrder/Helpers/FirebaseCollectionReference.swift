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
    case Cart
    case Items
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> FCollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
