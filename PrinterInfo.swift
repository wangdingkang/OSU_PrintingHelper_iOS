//
//  PrinterInfo.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/18/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class PrinterInfo {
    
    var name: String
    
    var location: String
    
    var type: String
    
    init(name: String, location: String, type: String) {
        self.name = name
        self.location = location
        self.type = type
    }
    
}