//
//  SendDataBackProtocal.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/19/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

protocol SendDataBackProtocol: class {
    
    func sendDataBack(tempUser: TempUser) -> Void
    
}