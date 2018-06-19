//
//  ChatMessageCell.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 18/06/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    //MARK: Stored properties
    var chatBubbleWidth: NSLayoutConstraint?
    var chatBubbleRightAnchor: NSLayoutConstraint?
    var chatBubbleLeftAnchor: NSLayoutConstraint?
    
    let chatBubble: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        
        return tv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        addSubview(chatBubble)
        addSubview(textView)
        addSubview(profileImageView)
        
        chatBubble.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: self.frame.height)
        chatBubbleWidth = chatBubble.widthAnchor.constraint(equalToConstant: 200)
        chatBubbleWidth?.isActive = true
        //Pin chatBubble to left or right
        chatBubbleRightAnchor = self.chatBubble.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        chatBubbleRightAnchor?.isActive = true
        chatBubbleLeftAnchor = self.chatBubble.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 8)
        chatBubbleLeftAnchor?.isActive = true
        
        textView.anchor(top: self.topAnchor, left: chatBubble.leftAnchor, bottom: self.bottomAnchor, right: chatBubble.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: self.frame.height)
        
        profileImageView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
