//
//  DocumentFile.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/18/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class DocumentFile {

    var filename: String
    
    var filesize: UInt64
    
    var modifiedTime: NSDate?
    
    init(filename: String, filesize: UInt64, modifiedTime: NSDate?){
        self.filename = filename
        self.filesize = filesize
        self.modifiedTime = modifiedTime
    }
    
    var filesizeInString: String {
        get {
            if filesize < 1024 {
                return "\(filesize) B"
            } else if filesize < 1024 * 1024 {
                return "\(filesize / 1024) KB"
            } else if filesize < 1024 * 1024 * 1024 {
                return "\(filesize / (1024 * 1024)) MB"
            } else {
                return "more than 1GB"
            }
        }
    }
    
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