//
//  ChatLogVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 12/06/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class ChatLogVC: UICollectionViewController {
    
    //MARK: Stored properties
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
        navigationItem.title = "Chat Log VC"
        collectionView?.backgroundColor = .white
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
        
        let values: [String : Any] = ["text" : text]
        
        let databaseRef = Database.database().reference().child("messages")
        databaseRef.childByAutoId().updateChildValues(values) { (err, _) in
            if let error = err {
                print("Error pushing message node to database: ", error); return
            }
        }
        
        
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



