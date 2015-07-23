//
//  PrintingHistory.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/21/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation
import CoreData

@objc (PrintingHistory)
class PrintingHistory: NSManagedObject {

    @NSManaged var filename: String
    @NSManaged var printedAt: NSDate

}
