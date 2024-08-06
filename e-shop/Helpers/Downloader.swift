//
//  Downloader.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 01.08.2024.
//

import Foundation
import FirebaseStorage
import UIKit

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping(_ imageLinks: [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { imageLink in
                
                if imageLink != nil {
                    
                    imageLinkArray.append(imageLink!)
                    
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count {
                        
                        completion(imageLinkArray)
                    }
                }
            }
            
            nameSuffix += 1
        }
        
    } else {
        
        debugPrint("No Internet Connection")
    }
}

func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping(_ imageLink: String?) -> Void) {
    
    var task: StorageUploadTask!
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, completion: { metaData, error in
        
        task.removeAllObservers()
        
        if error != nil {
            
            debugPrint("Uploading Error: \(error?.localizedDescription)")
            completion(nil)
            return
        } else {
            
            storageRef.downloadURL { url, error in
                
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        }
    })
}

func downloadImages(imageURLs: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
    
    var imageArray: [UIImage] = []
    var downloadCounter = 0
    
    for link in imageURLs {
        
        let url = NSURL(string: link)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                
                imageArray.append(UIImage(data: data! as Data)!)
                
                if downloadCounter == imageArray.count {
                    
                    DispatchQueue.main.async {
                        
                        completion(imageArray)
                    }
                }
            } else {
                debugPrint("couldnt download image")
                completion(imageArray)
            }
        }
    }
}
