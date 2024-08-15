//
//  MUser.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 13.08.2024.
//

import Foundation
import FirebaseAuth

class MUser {
    
    var objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    init(objectId: String, email: String, firstName: String, lastName: String) {
        self.objectId = objectId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        fullName = firstName + " " + lastName
        purchasedItemIds = []
        fullAddress = ""
        onBoard = false
    }
    
    init(dictionary: NSDictionary) {
        
        objectId = dictionary[kOBJECTID] as! String
        
        if let email = dictionary[kEMAIL] {
            self.email = email as! String
        } else {
            self.email = ""
        }
        
        if let firstName = dictionary[kFIRSTNAME] {
            self.firstName = firstName as! String
        } else {
            self.firstName = ""
        }
        
        if let lastName = dictionary[kLASTNAME] {
            self.lastName = lastName as! String
        } else {
            self.lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let purchasedItemIds = dictionary[kPURCHASEDITEMIDS] {
            self.purchasedItemIds = purchasedItemIds as! [String]
        } else {
            self.purchasedItemIds = []
        }
        
        if let fullAddress = dictionary[kFULLADDRESS] {
            self.fullAddress = fullAddress as! String
        } else {
            self.fullAddress = ""
        }
        
        if let onBoard = dictionary[kONBOARD] {
            self.onBoard = onBoard as! Bool
        } else {
            self.onBoard = false
        }
    }
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> MUser? {
        
        if Auth.auth().currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return MUser(dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userdId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    
                    print("email isn't varified")
                    completion(error, false)
                }
            } else {
                
                completion(error, false)
            }
        }
    }
    
    //MARK: - Register User
    class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            
            completion(error)
            
            if error == nil {
                
                authDataResult!.user.sendEmailVerification { error in
                    
                    print("auth email verification error: \(error!.localizedDescription)")
                }
            }
        }
    }
}

//MARK: - Download User

func downloadUserFromFirestore(userdId: String, email: String) {
    
    FirebaseReference(.User).document(userdId).getDocument { snapshot, error in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            
            //Download user if it exist
            saveUserLocaly(mUserDictionary: snapshot.data()! as NSDictionary)
            
        } else {
            
            //There is no user. Save new in Firestore
            let user = MUser(objectId: userdId, email: email, firstName: "", lastName: "")
            saveUserLocaly(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
    }
}

//MARK: - Save User to Firebase

func saveUserToFirestore(mUser: MUser) {
    
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String : Any]) { error in
        
        if error != nil {
            
            debugPrint("Error saving a user: \(error!.localizedDescription)")
        }
    }
        }

func saveUserLocaly(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: - Helper Function

func userDictionaryFrom(user: MUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIds], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying])
}
