//
//  MainVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 21/04/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc fileprivate func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout error: ", error)
            return
        }
        
        let loginVC = LoginVC()
        present(loginVC, animated: true, completion: nil)
    }
}

