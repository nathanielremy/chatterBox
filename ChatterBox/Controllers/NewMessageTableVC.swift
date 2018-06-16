//
//  NewMessageTableVC.swift
//  ChatterBox
//
//  Created by Nathaniel Remy on 07/05/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableVC: UITableViewController {
    
    //MARK: Stored properties
    let cellId = "cellId"
    var users = [User]()
    var messagesVC: MessagesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(NewMessageTableViewCell.self, forCellReuseIdentifier: cellId)
        fetchUsers()
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchUsers() {
        let databaseRef = Database.database().reference().child("users")
        databaseRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let snapshot = dataSnapshot.value as? [String : Any] else {
                print("Could not convert dataSnapshot elements..."); return
            }
            
            snapshot.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else {
                    print("Could not convert"); return
                }
                let user = User(uid: key, dictionary: dictionary)
                self.users.append(user)
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print("NewMessageTableVC/fetchUsers ERROR: ", error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewMessageTableViewCell
        
        let user = self.users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesVC?.showChatController(forUser: user)
        }
    }
    
    
}
