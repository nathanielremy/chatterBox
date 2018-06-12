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
            
            self.setupUserNavBar(user: user)
            
        }, withCancel: { (error) in
            print("MessagesVC/checkIfUserIsLoggedIn: Error: ", error)
        })
    }
    
    fileprivate func setupUserNavBar(user: User) {
        let containerView = UIView()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = .red
        self.navigationItem.titleView = titleView
        titleView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
        let imageView = CustomImageView()
        DispatchQueue.main.async {
            imageView.loadImage(from: user.profileImageURLString)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40/2
        imageView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        
        containerView.addSubview(imageView)
        imageView.anchor(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.addSubview(nameLabel)
        nameLabel.anchor(top: nil, left: imageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: 40)
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    @objc func showChatController() {
        let chatLogVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogVC, animated: true)
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

