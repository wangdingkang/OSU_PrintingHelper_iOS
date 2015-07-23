//
//  TempUser.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/19/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class TempUser: NSObject, NSCoding {
    
    var username: String
    var password: String
    var department: String
    
    private enum KeysForProperties: String {
        case keyForUsername = "username"
        case keyForPassword = "password"
        case keyForDepartment = "department"
    }
    
    init(username: String, password: String, department: String ) {
        self.username = username
        self.password = password
        self.department = department
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObjectForKey(KeysForProperties.keyForUsername.rawValue) as! String
        self.password = aDecoder.decodeObjectForKey(KeysForProperties.keyForPassword.rawValue) as! String
        self.department = aDecoder.decodeObjectForKey(KeysForProperties.keyForDepartment.rawValue) as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.username, forKey: KeysForProperties.keyForUsername.rawValue)
        aCoder.encodeObject(self.password, forKey: KeysForProperties.keyForPassword.rawValue)
        aCoder.encodeObject(self.department, forKey: KeysForProperties.keyForDepartment.rawValue)
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if  object == nil || !(object! is TempUser){
            return false
        } else {
            let compareTo = object as! TempUser
            return self.username == compareTo.username && self.password == compareTo.password && self.department == compareTo.department
        }
    }
    
}