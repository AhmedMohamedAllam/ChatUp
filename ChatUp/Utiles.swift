//
//  Utiles.swift
//  ForYou
//
//  Created by LinuxPlus on 6/9/17.
//  Copyright © 2017 E&S. All rights reserved.
//

import Foundation
import UIKit

class Utiles{
    static func circleView(view: UIView){
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = true;
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
    }

    static func createAlertWithMessage(title:String , message:String) -> UIAlertController{
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    static func checkIsEmpty(textFields : UITextField...) -> Bool{
        for textField in textFields{
            if textField.text == ""{
                textField.becomeFirstResponder();
                return true
            }
        }
        return false
    }


}
