//
//  UserService.swift
//  Photoapp
//
//  Created by Kim on 20/9/20.
//  Copyright © 2020 Kim. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func createProfile(userId:String, username:String, completion: @escaping (PhotoUser?) -> Void) {
        
        // Create a dictionary for the profile data
        let profileData = ["username":username]
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Create the document for the userid
        db.collection("users").document(userId).setData(profileData) { (error) in
            
            // Check for the errors
            if error == nil {
                // Profile was create successfully
                // Create and return a photo user
                var u = PhotoUser()
                u.username = username
                u.userId = userId
                
                completion(u)
            }
            else {
                // Something went wrong
                // Return nil
                completion(nil)
            }
            
        }
        
    }
    
    static func retrieveProfile(userID:String, completion: @escaping (PhotoUser?) -> Void) {
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Check for a profile , given the user id
        db.collection("users").document(userID).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                
                // Something wrong happend
                return
            }
            
            if let profile = snapshot!.data() {
                // Profile was found, create a new Photo user
                
                var u = PhotoUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                
                // Return the user
                completion(u)
            }
            else {
                // Could not get profile, no profile
                // Return nil
                completion(nil)
            }
        }
    }
    
}
