//
//  TaskFinishedProtocol.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 15/7/22.
//  Copyright (c) 2015年 Dingkang Wang. All rights reserved.
//

import Foundation

protocol TaskFinishedProtocol: class {
    
    func taskFinishedfeedback(feedback: String) -> Void
    
}