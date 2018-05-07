//
//  User.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 07/05/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let name: String
    let email: String
    let profileImageURLString: String
    
    init(uid: String, dictionary: [String : Any]) {
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURLString = dictionary["profileImageURLString"] as? String ?? ""
    }
}
