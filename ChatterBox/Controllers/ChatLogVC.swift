//
//  ChatLogVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 12/06/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class ChatLogVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Stored properties
    let cellId = "cellId"
    var messages = [Message]()
    
    var user: User? {
        didSet {
            guard let user = user else { print("No user passed to ChatLogVC"); return }
            navigationItem.title = user.name
            observeMessages(forUser: user)
        }
    }
    
    func observeMessages(forUser user: User) {
        guard let userId = Auth.auth().currentUser?.uid else { print("No current user id"); return }
        let userMessagesRef = Database.database().reference().child("user-messages").child(userId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                let message = Message(key: snapshot.key, dictionary: dictionary)
                
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: { (nil) in
                return
            })
            
        }) { (error) in
            print("Error fetching user-messages for user: \(userId): ", error); return
        }
        
    }
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = UIColor.mainBlue()
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleSend() {
        guard let text = inputTextField.text, text != "" else {
            print("InputTextField is empty..."); return
        }
        
        sendMessageWith(text: text)
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.delegate = self
        
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
    }
    
    fileprivate func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 50)
        
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: nil)
        
        containerView.addSubview(inputTextField)
        inputTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .black
        
        containerView.addSubview(seperatorView)
        seperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    fileprivate func sendMessageWith(text: String) {
        
        guard let toId = self.user?.uid else { print("No user passed to ChatLogVC"); return }
        guard let fromId = Auth.auth().currentUser?.uid else { print("No current userId"); return }
        
        let values: [String : Any] = ["text" : text, "toId" : toId, "fromId" : fromId, "timeStamp" : Date().timeIntervalSince1970]
        
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        childRef.updateChildValues(values) { (err, _) in
            if let error = err {
                print("Error pushing message node to database: ", error); return
            }
        }
        
        let messageId = childRef.key
        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
        userMessagesRef.updateChildValues([messageId : 1]) { (err, _) in
            if let error = err { print("Error: ", error); return }
        }
        
        let recipientRef = Database.database().reference().child("user-messages").child(toId)
        recipientRef.updateChildValues([messageId: 1]) { (err, _) in
            if let error = err {
                print("ERROR: ", error)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.textView.text = self.messages[indexPath.item].text
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

extension ChatLogVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}

























