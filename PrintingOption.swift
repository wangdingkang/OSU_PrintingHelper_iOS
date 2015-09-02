//
//  PrintingOption.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 15/7/22.
//  Copyright (c) 2015年 Dingkang Wang. All rights reserved.
//

import Foundation

class PrintingOption {
    
    var printerName: String
    
    var copies: Int
    
    var isDuplex: Bool
    
    var isFitOnePage: Bool
    
    init(printerName: String, copies: Int, isDuplex: Bool, isFitOnePage: Bool) {
        self.printerName = printerName
        self.copies = copies
        self.isDuplex = isDuplex
        self.isFitOnePage = isFitOnePage
    }
    
}