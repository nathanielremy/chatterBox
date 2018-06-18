//
//  File.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 16/06/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    
    let messageKey: String
    let fromId: String
    let toId: String
    let text: String
    let timeStamp: Date
    
    func chatPartnerId() -> String? {
        return self.toId == Auth.auth().currentUser?.uid ? self.fromId : self.toId
    }
    
    init(key: String, dictionary: [String : Any]) {
        self.messageKey = key
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["timeStamp"] as? Double ?? 0
        self.timeStamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
