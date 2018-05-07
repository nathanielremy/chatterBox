//
//  NewMessageTableViewCell.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 07/05/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

