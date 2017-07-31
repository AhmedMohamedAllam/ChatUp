//
//  RoundedImageView.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/28/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
    }

}
