//
//  CreateProfileViewController.swift
//  Photoapp
//
//  Created by Kim on 19/9/20.
//  Copyright © 2020 Kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func confirmTapped(_ sender: Any) {
        
        // Check that there is a user logged in
        guard Auth.auth().currentUser != nil else {
            // No user logged in
            return
        }
        // Get the username
        // Check it against whitespaces, new lines, illegal charater etc
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that the username is not nil
        if username == nil || username == "" {
            // Show an error message
            return
        }
        
        // Call the user service to create the profile
        UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!) { (user) in
            
            // Check if it was create successfully
            if user != nil {
                // If so, go to the tab bar controller
                
                // Save the user to local storage
                LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController)
                
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
                
            }
            else {
                // If not, display error
                
            }
        }
        
        
    }
    
}
