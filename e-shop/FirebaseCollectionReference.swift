//
//  FirebaseCollectionReference.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 26.07.2024.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Categoty
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
