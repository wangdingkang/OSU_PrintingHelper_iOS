//
//  MyActivityIndicatorView.swift
//  OSU Printer
//
//  Created by Dingkang Wang on 7/21/15.
//  Copyright (c) 2015 Dingkang Wang. All rights reserved.
//

import Foundation
import UIKit

class MyActivityIndicatorView: UIView {

    var messageLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    init(frame: CGRect, message: String) {
        
        messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 180, height: 50))
        messageLabel.text = message
        messageLabel.textColor = UIColor.whiteColor()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.color = UIColor.whiteColor()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        self.alpha = 0.7
        self.layer.cornerRadius = 15
        
        self.addSubview(activityIndicator)
        self.addSubview(messageLabel)
        
        self.hidden = true
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeMessage (newMessage: String){
        messageLabel.text = newMessage
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        self.hidden = false
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.hidden = true
    }
    
}