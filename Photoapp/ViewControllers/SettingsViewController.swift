//
//  SettingsViewController.swift
//  Photoapp
//
//  Created by Kim on 19/9/20.
//  Copyright © 2020 Kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
        
        // Sign out with Firebase Auth
        do {
            // Try to sign the user
            try Auth.auth().signOut()
            
            // Clear local storage
            LocalStorageService.clearUser()
            
            // Transition to authentation flow
            let loginNavVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginNavController)
            
            self.view.window?.rootViewController = loginNavVC
            self.view.window?.makeKeyAndVisible()
        }
        catch {
            // Could not sign out the user
        }
    }
    
}
