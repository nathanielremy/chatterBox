//
//  NewMessageTableViewCell.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 07/05/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    
    //MARK: Stored properties
    var message: (Message?, User?) {
        didSet {
            
            guard let theMessage = message.0, let user = message.1 else {
                print("No message or user"); return
            }
            
            profileImageView.loadImage(from: user.profileImageURLString)
            nameLabel.text = user.name
            emailLabel.text = theMessage.text
            timeLabel.text = theMessage.timeStamp.timeAgoDisplay()
        }
    }
    
    var user: User? {
        didSet {
            guard let user = user else {
                print("No user..."); return
            }
            profileImageView.loadImage(from: user.profileImageURLString)
            nameLabel.text = user.name
            emailLabel.text = user.email
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkText
        label.textAlignment = .left
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkText
        label.textAlignment = .left
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50/2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.centerYAnchor, right: self.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        addSubview(emailLabel)
        emailLabel.anchor(top: profileImageView.centerYAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -8, width: 100, height: nil)
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

