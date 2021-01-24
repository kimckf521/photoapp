//
//  PhotoService.swift
//  Photoapp
//
//  Created by Kim on 22/9/20.
//  Copyright © 2020 Kim. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    static func retrievePhoto(completion: @escaping ([Photo]) -> Void) {
        
        // Get a database reference
        let db = Firestore.firestore()
        
        // Get all the documents fom the photos collection
        db.collection("photos").getDocuments { (snapshot, error) in
            
            // Check the error
            if error != nil {
                return
            }
            // Get all the documents
            let documents = snapshot?.documents
            
            // Check that docmuents are not nil
            if let documents = documents {
                
                // Create an aray to hold all of our photo structs
                var photoArray = [Photo]()
                
                // Loop through the documents, create a photo struct for each
                for doc in documents {
                    
                    let p = Photo(snapshot: doc)
                    
                    if p != nil {
                        
                        // Store it in the array
                        photoArray.insert(p!, at: 0)
                    }
                }
                
                // Pass back the photo array
                completion(photoArray)
            }
        }
        
        
        
    }
    static func savePhoto(image:UIImage, progressUpdate: @escaping (Double) -> Void ) {
        
        // Check that there is a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else{
            // Error could not get data from the UIImage
            return
        }
        
        // Create a filename
        let filename = UUID().uuidString
        
        // Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        // Create a firebace storage
        let ref = Storage.storage().reference().child("images/\(userId)/\(filename).jpg")
        
        // Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            // Check if upload was successful
            if error == nil {
                
                // Upon sucessful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
        }
        
        uploadTask.observe(.progress) { (taskSnapshot) in
            
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            
            print(pct)
            progressUpdate(pct)
            
        }
    }
    
    private static func createDatabaseEntry(ref: StorageReference) {
        
        // Download url
        ref.downloadURL { (url, error) in
            
            // If there is no error, then proceed
            
            if error == nil {
                
                // Photo id
                let photoId = ref.fullPath
                
                // Get the current user
                let photoUser = LocalStorageService.loadUser()
                
                // User id
                let userId = photoUser?.userId
                
                // User name
                let username = photoUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                
                let dateString = df.string(from: Date())
                
                // Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "byId":userId!, "byUsername":username!, "date":dateString, "url":url!.absoluteString]
                
                // Save the metadata to the firestore database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    // Check if the saving of data was sucessful
                    if error == nil {
                        // Successfully created database entry for the photo
                    }
                    
                }
            }
            
        }
        
        
    }
    
}
