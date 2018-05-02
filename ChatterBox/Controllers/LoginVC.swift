//
//  LoginVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 26/04/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //MARK: Stored properties
    var stackViewHeight: CGFloat = 150
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "gameofthrones_splash").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleSegmentedController), for: .valueChanged)
        
        return sc
    }()
    
    @objc fileprivate func handleSegmentedController() {
        var title: String
        if segmentedControl.selectedSegmentIndex == 0 {
            title = "Login"
            stackViewHeight = 100
        } else {
            title = "Register"
            stackViewHeight = 150
        }
        
        registerButton.setTitle(title, for: .normal)
        setupStackView()
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Name"
        tf.borderStyle = .line
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Email"
        tf.borderStyle = .line
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
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
        if segmentedControl.selectedSegmentIndex == 1 {
            registerUser()
        } else {
            loginUser()
        }
    }
    
    fileprivate func loginUser() {
        guard let inputs = areLoginInputsValid() else {
            print("OOOOps login inputs are not valid"); return
        }
        
        Auth.auth().signIn(withEmail: inputs.email, password: inputs.password) { (_, err) in
            if let error = err {
                print("Error loging in: ", error); return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func registerUser() {
        guard let inputs = areInputsValid() else {
            print("OOOOps register inputs are not valid"); return
        }
        
        Auth.auth().createUser(withEmail: inputs.email, password: inputs.password) { (userr, err) in
            if let error = err {
                print("Could not creat account... Error: ", error); return
            }
            guard let user = userr else {
                print("Could not creat account... Error: No user returned"); return
            }
            
            let userValues = ["name" : inputs.name, "email" : inputs.email]
            let values: [String : Any] = [user.uid : userValues]
            
            let databaseRef = Database.database().reference().child("users")
            databaseRef.updateChildValues(values, withCompletionBlock: { (err, _) in
                if let error = err {
                    print("Error uploading user's values to database: ", error)
                }
                
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainBlue()
        
        setupStackView()
    }
    
    fileprivate func areInputsValid() -> (name: String, email: String, password: String)? {
        
        guard let name = nameTextField.text, name.count > 0 else { return nil }
        guard let email = emailTextField.text, email.count > 0 else { return nil }
        guard let password = passwordTextField.text, password.count > 5 else { return nil }
        
        return (name, email, password)
    }
    
    fileprivate func areLoginInputsValid() -> (email: String, password: String)? {
        guard let email = emailTextField.text, email.count > 0 else { return nil }
        guard let password = passwordTextField.text, password.count > 5 else { return nil }
        
        return (email, password)
    }
    
    fileprivate func setupStackView() {
        
        var UIViewStack: [UIView] = [nameTextField, emailTextField, passwordTextField]
        
        if stackViewHeight == 100 {
            UIViewStack.remove(at: 0)
        }
        
        let stackView = UIStackView(arrangedSubviews: UIViewStack)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: -12, width: nil, height: stackViewHeight)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(registerButton)
        registerButton.anchor(top: passwordTextField.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 50)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: profileImageView.bottomAnchor, left: passwordTextField.leftAnchor, bottom: nil, right: passwordTextField.rightAnchor, paddingTop: 68, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 30)
    }
    
    
    
    
    
    
    
    
    
}
