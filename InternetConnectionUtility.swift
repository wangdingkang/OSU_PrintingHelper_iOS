//
//  Utility.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/15/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation

class InternetConnectionUtility {
    
    static func getMetworkStatus() -> NetworkStatus {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        return reachability.currentReachabilityStatus()
    }
    
    
    
}