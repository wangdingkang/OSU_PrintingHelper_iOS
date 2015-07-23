//
//  KeyboardObserver.swift
//  Toast
//
//  Created by Hannes Lohmander on 13/07/15.
//  Copyright (c) 2015 Lohmander. All rights reserved.
//

import Foundation

class KeyboardObserver: NSObject {
    var offset: CGFloat = 0
    
    required override init() {
        super.init()
        
        let nc = NSNotificationCenter.defaultCenter()
        
        nc.addObserver(self, selector: "keyboardDidAppear:", name: UIKeyboardDidShowNotification, object: nil)
        nc.addObserver(self, selector: "keyboardDidDisappear:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidAppear(notification: NSNotification) -> Void {
        let info = notification.userInfo
        let keyboardFrame = info?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSize = keyboardFrame?.CGRectValue().size
        
        if let kS = keyboardSize {
            offset = kS.height
        }
    }
    
    func keyboardDidDisappear(notification: NSNotification) -> Void {
        offset = 0
    }
}