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
    
    var fileType: FileType {
        let ex = filename.pathExtension.lowercaseString
        switch ex {
        case "jpg", "jpeg":
            return .JPG
        case "png":
            return .PNG
        case "doc":
            return .DOC
        case "docx":
            return .DOCX
        case "pdf":
            return .PDF
        default:
            return .UNKNOWN
        }
    }
    
}
