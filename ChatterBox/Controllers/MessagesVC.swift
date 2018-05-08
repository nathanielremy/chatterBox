//
//  MessagesVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 21/04/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    @objc fileprivate func handleNewMessage() {
        let newMessageTableVC = NewMessageTableVC()
        navigationController?.pushViewController(newMessageTableVC, animated: true)
    }
    
    fileprivate func checkIfUserIsLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            
            self.fethcUserAndUpdateNavBar(fromUID: uid)
            
        } else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    func fethcUserAndUpdateNavBar(fromUID uid: String) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
            guard let snapshot = dataSnapshot.value as? [String : Any] else {
                print("Could not convert dataSnapshot elements"); return
            }
            
            let user = User(uid: dataSnapshot.key, dictionary: snapshot)
            
            DispatchQueue.main.async {
                self.navigationItem.title = user.name
            }
            
        }, withCancel: { (error) in
            print("MessagesVC/checkIfUserIsLoggedIn: Error: ", error)
        })
    }
    
    @objc fileprivate func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout error: ", error)
            return
        }
        
        let loginVC = LoginVC()
        loginVC.messagesVC = self
        present(loginVC, animated: true, completion: nil)
    }
}

