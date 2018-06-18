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
    
    let chatBubble: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 0, g: 137, b: 249)
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
        
        chatBubble.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: -8, width: nil, height: self.frame.height)
        chatBubbleWidth = chatBubble.widthAnchor.constraint(equalToConstant: 200)
        chatBubbleWidth?.isActive = true
        
        textView.anchor(top: self.topAnchor, left: chatBubble.leftAnchor, bottom: self.bottomAnchor, right: chatBubble.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: nil, height: self.frame.height)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
