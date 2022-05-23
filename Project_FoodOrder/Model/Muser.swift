//
//  Muser.swift
//  Project_FoodOrder
//
//  Created by DeepTM on 23/05/2022.
//

import Foundation
import FirebaseAuth

class Muser{
    let objectId: String
    var email: String
    var fullName: String
    var firstName: String
    var lastName: String
    var purchasedItemIds: [String]
    
    var fullAddress: String?
    var onboard: Bool
    
    //MARK: -Initializers
    init(_objectId: String, _email: String, _firstName: String, _lastName: String){
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + "" + _lastName
        fullAddress = ""
        onboard = false
        purchasedItemIds = []
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary[KOBJECTID] as! String
        
        if let mail = _dictionary[KEMAIL]{
            email = mail as! String
        }
        else{
            email = ""
        }
        
        if let fname = _dictionary[KFIRSTNAME]{
            firstName = fname as! String
        }
        else{
            firstName = ""
        }
        if let lname = _dictionary[KLASTNAME]{
            lastName = lname as! String
        }
        else{
            lastName = ""
        }
        
        fullName = firstName + "" + lastName
        if let faddress = _dictionary[KFULLADDRESS]{
            fullAddress = faddress as! String
        }
        else{
            fullAddress = ""
        }
        
        if let onB = _dictionary[KONBOARD]{
            onboard = onB as! Bool
        }
        else{
            onboard = false
        }
        
        if let purchaseIds = _dictionary[KPURCHASEDITEMIDS]{
           purchasedItemIds = purchaseIds as! [String]
        }
        else{
            purchasedItemIds = []
        }
    }
    
    //MARK: Return current user
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser()-> Muser?{
        if Auth.auth().currentUser != nil{
            if let dictionary = UserDefaults.standard.object(forKey: KCURRENTUSER){
                return Muser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //MARK: Login func
    class func loginUserWith(email: String, password: String, completion: @escaping (_ Error: Error?, _ isEmailVerified: Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){(AuthDataResult, error) in
            if error == nil{
                
                if AuthDataResult!.user.isEmailVerified{
                    downloadUserFronFirestore(userId: AuthDataResult!.user.uid, email: email)
                    completion(error, true)

                }
                else{
                    print("Email is not")
                    completion(error, false)
                }
                
            } else{
                completion(error, false)

            }
        }
    }
    
    //MARK: Register user
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {(AuthDataResult, error) in
            completion(error)
            if error == nil{
                //send email verfiaction
                AuthDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error: ", error?.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Resend link methods
    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            print("resend email error: ", error?.localizedDescription)
            completion(error)
        })
    }
}

//MARK: DownloadUser
func downloadUserFronFirestore(userId: String, email: String) {
    FirebaseReference(.User).document(userId).getDocument {(snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists{
        print("download current user from firestore")
        saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
            
        }else{
            //there is no user, save new in firestore
            
            let user = Muser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveToFirestore(mUser: user)
        }
    }
    
}


//MARK: Save user to firebase

func saveToFirestore(mUser: Muser){
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String : Any]) { (error) in
        if error != nil{
            print("error saving user \(error!.localizedDescription)")
        }
    }
}

func  saveUserLocally(mUserDictionary: NSDictionary) {
    UserDefaults.standard.set(mUserDictionary, forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: Helper Function
func userDictionaryFrom(user: Muser) -> NSDictionary{
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onboard, user.purchasedItemIds], forKeys: [KOBJECTID as NSCopying, KEMAIL as NSCopying, KFIRSTNAME as  NSCopying, KLASTNAME as NSCopying, KFULLNAME as NSCopying, KFULLADDRESS as NSCopying, KONBOARD as NSCopying, KPURCHASEDITEMIDS as NSCopying])
}

//MARK: Update user
func updateCurrentUserInFirestore(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void){
    
    if let dictionary = UserDefaults.standard.object(forKey: KCURRENTUSER){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(Muser.currentId()).updateData(withValues){ (error) in
            completion(error)
            
            if error == nil{
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}
