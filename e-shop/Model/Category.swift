//
//  Categoty.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 26.07.2024.
//

import Foundation
import SwiftUI

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(name: String, imageName: String) {
        id = ""
        self.name = name
        self.imageName = imageName
        image = UIImage(named: imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: - Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Categoty).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}


//MARK: - Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//MARK - To create data in Firebase 
//func createCategorySet() {
//    
//    let womenClothing = Category(name: "Women's Clothing & Accessories", imageName: "womenCloth")
//    let footWaer = Category(name: "Footwaer", imageName: "footWaer")
//    let electronics = Category(name: "Electronics", imageName: "electronics")
//    let menClothing = Category(name: "Men's Clothing & Accessories" , imageName: "menCloth")
//    let health = Category(name: "Health & Beauty", imageName: "health")
//    let baby = Category(name: "Baby Stuff", imageName: "baby")
//    let home = Category(name: "Home & Kitchen", imageName: "home")
//    let car = Category(name: "Automobiles & Motorcyles", imageName: "car")
//    let luggage = Category(name: "Luggage & bags", imageName: "luggage")
//    let jewelery = Category(name: "Jewelery", imageName: "jewelery")
//    let hobby =  Category(name: "Hobby, Sport, Traveling", imageName: "hobby")
//    let pet = Category(name: "Pet products", imageName: "pet")
//    let industry = Category(name: "Industry & Business", imageName: "industry")
//    let garden = Category(name: "Garden supplies", imageName: "garden")
//    let camera = Category(name: "Cameras & Optics", imageName: "camera")
//    
//    let arrayOfCategories = [womenClothing, footWaer, electronics, menClothing, health, baby, home, car, luggage, jewelery, hobby, pet, industry, garden, camera]
//    
//    for category in arrayOfCategories {
//        saveCategoryToFirebase(category)
//    }
//}
