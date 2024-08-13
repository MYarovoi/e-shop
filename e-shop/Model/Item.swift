//
//  Item.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 30.07.2024.
//

import Foundation
import UIKit

class Item {
    
    var id: String!
    var categotyId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kOBJECTID] as? String
        categotyId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}

func saveItemToFirebase(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categotyId, item.name, item.description, item.price, item.imageLinks], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
}

func downloadItemFromFirebase(withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { shanpshot, error in
        
        guard let snapshot = shanpshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
}

func downloadItems(_ withIDs: [String], completion: @escaping(_ itemArray: [Item]) -> Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIDs.count > 0 {
        
        for itemID in withIDs {
            
            FirebaseReference(.Items).document(itemID).getDocument { snapshot, error in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                if snapshot.exists {
                    
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                } else {
                    completion(itemArray)
                }
                
                if count == withIDs.count {
                    
                    completion(itemArray)
                }
            }
        }
    } else {
        
        completion(itemArray)
    }
}
