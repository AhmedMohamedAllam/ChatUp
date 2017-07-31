//
//  ChatViewController.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/28/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController{
    
    @IBOutlet weak var statusLAbel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var writeMessageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var receiver: User?
    var myUid: String = (Auth.auth().currentUser?.uid)!
    
    var messegeRef = Database.database().reference().child("messages")
    var receiverMessageRef = Database.database().reference().child("messages")
    
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chatId = "\(myUid)\((receiver?._uid)!)"
        let receiverChatId = "\((receiver?._uid)!)\(myUid)"
        
        messegeRef = messegeRef.child(chatId)
        receiverMessageRef = receiverMessageRef.child(receiverChatId)
        
        observeNewMessage()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let user = receiver{
            usernameLabel.text = user.fullName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        messegeRef.removeAllObservers()
    }
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func observeNewMessage(){
        messegeRef.observe(.childAdded, with: { (snapshot) in
            let newMessageDict = snapshot.value as! [String: Any]
            if let newMessage = Message.dictionaryToMessage(dict: newMessageDict){
                self.messages.append(newMessage)
            }
            self.collectionView.reloadData()
            print("ahmed")
        })
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if(writeMessageTextField.text != ""){
            let messageText = writeMessageTextField.text!
            let messageDate:Double = Date().timeIntervalSince1970
            let messageFrom = myUid
            let messageTo = (receiver?._uid)!
            
            let messageObj = Message(_message: messageText, _from: messageFrom, _to: messageTo, _date: messageDate)
            let messageDict = Message.messageToDictionary(message: messageObj)
            
            let messageId: String = messegeRef.childByAutoId().key
            messegeRef.child(messageId).setValue(messageDict)
            receiverMessageRef.child(messageId).setValue(messageDict)
            
            writeMessageTextField.text = ""
        }
    }
    
    

}

extension ChatViewController: UICollectionViewDelegate{
    
}

extension ChatViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCellIdentifier", for: indexPath) as! ChatCollectionViewCell
        let currentMessage:Message = messages[indexPath.row]
        cell.messageTextView.layer.cornerRadius = 15
        cell.messageTextView.layer.masksToBounds = true
        cell.messageTextView.isEditable = false
        cell.messageTextView.text = currentMessage.message
        let sender = currentMessage.from

        if(sender == myUid){
            //my outgoing messages
            cell.messageTextView.backgroundColor = UIColor.clear
            cell.messageTextView.backgroundColor = UIColor(red: 0, green: 137/250, blue: 249/250, alpha: 1)
            cell.profilePic.isHidden = true
            let horizontalConstraint = NSLayoutConstraint(item: cell.messageTextView, attribute: NSLayoutAttribute.rightMargin, relatedBy: NSLayoutRelation.equal, toItem: cell, attribute: NSLayoutAttribute.rightMargin, multiplier: 1, constant: 0)
            cell.addConstraint(horizontalConstraint)
            
        }else{
            
            cell.messageTextView.backgroundColor = UIColor.clear
            cell.messageTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.profilePic.isHidden = false
            
        }
        
        
        return cell
    }
    
    
}

extension ChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message:String = messages[indexPath.row].message
        let size = CGSize(width: self.view.frame.width , height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)], context: nil)
        return CGSize(width: self.view.frame.width - 20, height: estimatedFrame.height + 20)
    }
}


