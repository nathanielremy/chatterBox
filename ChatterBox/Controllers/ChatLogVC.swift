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
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var user: User? {
        didSet {
            guard let user = user else { print("No user passed to ChatLogVC"); return }
            navigationItem.title = user.name
            observeMessages(forUser: user)
        }
    }
    
    func observeMessages(forUser user: User) {
        guard let userId = Auth.auth().currentUser?.uid else { print("No current user id"); return }
        guard let chatPartnerId = self.user?.uid else { print("No user in stored property"); return }
        let userMessagesRef = Database.database().reference().child("user-messages").child(userId).child(chatPartnerId)
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
                        //Make collectionView scroll to bottom when message is sent and/or recieved
                        self.collectionView?.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
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
        button.tintColor = UIColor.rgb(r: 0, g: 137, b: 249)
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
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 58, 0)
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyBoardObservers()
    }
    
    //Never forget to remove observers
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyBoardWillShow(notifaction: NSNotification) {
        //Get the height of the keyBoard
        let keyBoardFrame = (notifaction.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyBoardDuration: Double = (notifaction.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        if let height = keyBoardFrame?.height {
            self.containerViewBottomAnchor?.constant = -height + view.safeAreaInsets.bottom
            //Animate the containerView going up
            UIView.animate(withDuration: keyBoardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleKeyBoardWillHide(notifaction: NSNotification) {
        //Move the keyboard back down
        let keyBoardDuration: Double = (notifaction.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        self.containerViewBottomAnchor?.constant = 0
        //Animate the containerView going down
        UIView.animate(withDuration: keyBoardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 50)
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: nil)
        
        containerView.addSubview(inputTextField)
        inputTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .black
        
        containerView.addSubview(seperatorView)
        seperatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)    }
    
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
        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
        userMessagesRef.updateChildValues([messageId : 1]) { (err, _) in
            if let error = err { print("Error: ", error); return }
        }
        
        let recipientRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
        recipientRef.updateChildValues([messageId: 1]) { (err, _) in
            if let error = err {
                print("ERROR: ", error)
            }
        }
        
        self.inputTextField.text = nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = self.messages[indexPath.item]
        
        cell.textView.text = message.text
        
        setupChatMessageCell(cell: cell, message: message)
        
        //Modifyig the chat bubble's width
        if let text = self.messages[indexPath.item].text as? String {
            cell.chatBubbleWidth?.constant = estimatedFrameForChatBubble(fromText: text).width + 32
        }
        
        return cell
    }
    
    fileprivate func setupChatMessageCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageURLString = self.user?.profileImageURLString {
            cell.profileImageView.loadImage(from: profileImageURLString)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //Display blue chatBubble
            cell.chatBubble.backgroundColor = UIColor.rgb(r: 0, g: 137, b: 249)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.chatBubbleLeftAnchor?.isActive = false
            cell.chatBubbleRightAnchor?.isActive = true
        } else {
            //Display gray chatBubble
            cell.chatBubble.backgroundColor = UIColor.rgb(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.chatBubbleLeftAnchor?.isActive = true
            cell.chatBubbleRightAnchor?.isActive = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //Modifying thr chat bubble's height
        if let text = self.messages[indexPath.item].text as? String {
            height = self.estimatedFrameForChatBubble(fromText: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func estimatedFrameForChatBubble(fromText text: String) -> CGRect {
        // height must be something really tall and width is the same as chatBubble in ChatMEssageCell
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [.font : UIFont.systemFont(ofSize: 16)], context: nil)
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

























