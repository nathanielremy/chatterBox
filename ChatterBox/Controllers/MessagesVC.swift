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
    
    //MARK: Stored properties
    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelectionDuringEditing = true
    }
    
    func observeUserMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { print("Could not fetch currentUserId"); return }
        
        let ref = Database.database().reference().child("user-messages").child(currentUserId)
        ref.observe(.childAdded, with: { (snapShot) in
            
            let userId = snapShot.key
            let userRef = Database.database().reference().child("user-messages").child(currentUserId).child(userId)
            userRef.observe(.childAdded, with: { (snapshot2) in
                
                let messageId = snapshot2.key
                self.fetchMessage(withMessageId: messageId)
                
            }, withCancel: { (error) in
                print("Error fetching messages: ", error); return
            })
        }) { (error) in
            print("ERROR: ", error); return
        }
        
        ref.observe(.childRemoved, with: { (snapshot3) in
            self.messagesDictionary.removeValue(forKey: snapshot3.key)
            self.attemptReloadTable()
        }) { (error) in
            print("Error fetching data when child removed: ", error); return
        }
    }
    
    fileprivate func attemptReloadTable() {
        //Solution to only reload tableView once
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handleReloadTableView), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTableView() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (msg1, msg2) -> Bool in
            return Double(msg1.timeStamp.timeIntervalSince1970) > Double(msg2.timeStamp.timeIntervalSince1970)
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func fetchMessage(withMessageId messageId: String) {
        let messagesRef = Database.database().reference().child("messages").child(messageId)
        messagesRef.observeSingleEvent(of: .value, with: { (snapShot3) in
            
            guard let dictionary = snapShot3.value as? [String : Any] else { print("snapShot not convertible to [String : Any]"); return }
            
            let message = Message(key: snapShot3.key, dictionary: dictionary)
            
            //Grouping all messages per user
            if let chatPartnerId = message.chatPartnerId() {
                self.messagesDictionary[chatPartnerId] = message
            }
            
            //Solution to only reload tableView once
            self.attemptReloadTable()
            
        }, withCancel: { (error) in
            print("ERROR: ", error); return
        })
    }
    
    @objc fileprivate func handleNewMessage() {
        let newMessageVC = NewMessageTableVC()
        newMessageVC.messagesVC = self
        let newMessageNavVC = UINavigationController(rootViewController: newMessageVC)
        self.present(newMessageNavVC, animated: true, completion: nil)
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
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        self.tableView.reloadData()
        
        observeUserMessages()
        
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
    }
    
    func showChatController(forUser user: User) {
        let chatLogVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogVC.user = user
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
    
    //Enable the tableView to delete messages
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //What happens when user hits delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { print("Could not fetch current user Id"); return }
        guard let chatParterId = self.messages[indexPath.row].chatPartnerId() else { print("Could not fetch chatPartnerId"); return }
        
        let deleteRef = Database.database().reference().child("user-messages").child(currentUserId).child(chatParterId)
        deleteRef.removeValue { (err, _) in
            if let error = err {
                print("Error deleting value from database: ", error)
                return
            }
            
            self.messagesDictionary.removeValue(forKey: chatParterId)
            self.attemptReloadTable()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewMessageTableViewCell
        
        let message = self.messages[indexPath.row]
        
        if let uId = message.chatPartnerId() {
            Database.fetchUserFromUserID(userID: uId) { (userr) in
                guard let user = userr else { print("Could not fetch user from Database"); return }
                
                DispatchQueue.main.async {
                    cell.message = (message, user)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        
        //Select correct user to show in ChatLogVC
        guard let uId = message.chatPartnerId() else { print("No chat partner Id"); return }
        Database.fetchUserFromUserID(userID: uId) { (userr) in
            guard let user = userr else { print("No user returned from database"); return }
            
            DispatchQueue.main.async {
                self.showChatController(forUser: user)
            }
        }
    }
}

