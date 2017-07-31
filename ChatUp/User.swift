//
//  User.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/27/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import Foundation
import UIKit
class User {
    
    var _uid: String
    var profileImgPath : String
    var firstName : String
    var lastName : String
    var email: String
    
    var fullName : String{
        get{
            return "\(self.firstName) \(self.lastName)"
        }
    }
    
    init(uid:String, imgPath:String, fName:String, lName: String, Email: String) {
        self._uid = uid
        self.profileImgPath = imgPath
        self.firstName = fName
        self.lastName = lName
        self.email = Email
    }
    
    static func UserToDictionary(user: User) -> [String: String]{
         let userDict = [
            "_uid" : user._uid,
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            "email" : user.email,
            "profileImgPath" : user.profileImgPath ]
        return userDict
    }
    
    static func DictionaryToUser(dict:[String:String]) -> User?{
        var user: User?
        
        if let _uid = dict["_uid"],  let _fname = dict["firstName"], let _lname = dict["lastName"], let _imagePath = dict["profileImgPath"], let _email = dict["email"]{
            user = User(uid: _uid, imgPath: _imagePath, fName: _fname, lName: _lname, Email: _email)
        }
        
        return user
    }
    
}
