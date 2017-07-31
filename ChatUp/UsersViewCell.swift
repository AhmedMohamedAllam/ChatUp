//
//  UsersViewCell.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/30/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import UIKit

class UsersViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utiles.circleView(view: profilePic)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(name: String){
        username.text = name
    }
    
}
