//
//  LoginVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 26/04/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "gameofthrones_splash").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let nameTextFild: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Name"
        tf.borderStyle = .line
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let emailTextFild: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Email"
        tf.borderStyle = .line
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let passwordTextFild: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 80, g: 101, b: 161)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleRegisterButton() {
        print("Register button")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainBlue()
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [nameTextFild, emailTextFild, passwordTextFild])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: nil, height: 150)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(registerButton)
        registerButton.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 50)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
