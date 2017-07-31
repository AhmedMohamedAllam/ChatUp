//
//  ChatCollectionViewCell.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/30/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    
    override func awakeFromNib() {
        Utiles.circleView(view: profilePic)
    }

}
