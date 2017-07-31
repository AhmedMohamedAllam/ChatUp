//
//  Message.swift
//  ChatUp
//
//  Created by LinuxPlus on 7/31/17.
//  Copyright © 2017 Allam. All rights reserved.
//

import Foundation

class Message{
    
    var date: Double
    var from:String
    var to: String
    var message: String
    
    
    init( _message:String, _from:String, _to:String,  _date:Double) {
        self.message = _message
        self.from = _from
        self.to = _to
        self.date = _date
    }
    
    
    static func messageToDictionary(message: Message) -> [String: Any]{
        let userDict = [
            "date" : message.date,
            "from" : message.from,
            "to" : message.to,
            "message" : message.message] as [String : Any]
        return userDict
    }
    
    static func dictionaryToMessage(dict:[String:Any]) -> Message?{
        var message: Message?
        
        if let messsage = dict["message"],  let from = dict["from"], let to = dict["to"], let date = dict["date"]{
            message = Message(_message: messsage as! String, _from: from as! String, _to: to as! String, _date: date as! Double)
        }
        
        return message
    }

    
}
