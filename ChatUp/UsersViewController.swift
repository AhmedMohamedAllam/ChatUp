//
//  UsersViewController.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/30/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UsersViewController: UIViewController {

    var usersRef:DatabaseQuery?
    var usersHandler:DatabaseHandle?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var users:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        usersRef = Database.database().reference().child("users")
        ObserveUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let handler = usersHandler{
            usersRef?.removeObserver(withHandle: handler)
        }
    }

    
    @IBAction func logoutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func ObserveUsers(){
        let myUid = Auth.auth().currentUser?.uid
        usersHandler = usersRef?.observe(.childAdded, with: { (snapshot) in
            self.activityIndicator.stopAnimating()
            let newUserDict = snapshot.value as! [String: String]
            if let newUser = User.DictionaryToUser(dict: newUserDict){
                if(newUser._uid != myUid){
                    self.users.append(newUser)
                }
            }
            self.tableView.reloadData()
        })
    }
}


extension UsersViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatViewControllerIdentifier") as! ChatViewController
        let user = users[indexPath.row]
        ChatVC.receiver = user
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(ChatVC, animated: true, completion: nil)
        
    }
}

extension UsersViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userViewCellIdentifier", for: indexPath) as! UsersViewCell
        let user = users[indexPath.row]
        cell.configureCell(name: user.fullName)
        return cell
    }
}
