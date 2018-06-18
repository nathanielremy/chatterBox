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
    let textView: UITextView = {
        let tf = UITextView()
        tf.text = "SOME sample TEXT"
        tf.font = UIFont.systemFont(ofSize: 16)
        
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        addSubview(textView)
        textView.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: nil)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
