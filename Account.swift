//
//  Account.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/14/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation
import CoreData

@objc (Account)
class Account: NSManagedObject {

    @NSManaged var username: String
    @NSManaged var password: String
    @NSManaged var department: String

}
