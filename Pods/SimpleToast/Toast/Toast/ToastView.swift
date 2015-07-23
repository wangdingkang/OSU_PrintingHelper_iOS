//
//  ToastView.swift
//  Toast
//
//  Created by Hannes Lohmander on 13/07/15.
//  Copyright (c) 2015 Lohmander. All rights reserved.
//

import Foundation

class ToastView: UIView {
    var blurEffectView: UIVisualEffectView?
    var textLabel: UILabel?
    
    private var constraintsSet: Bool = false
    
    required init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.alpha = 0
        
        if Toast.appearance.blur {
            let blurEffect = UIBlurEffect(style: Toast.appearance.blurStyle)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.setTranslatesAutoresizingMaskIntoConstraints(false)
            blurEffectView?.layer.cornerRadius = 5
            blurEffectView?.clipsToBounds = true
            
            self.addSubview(blurEffectView!)
        }
        
        textLabel = UILabel()
        textLabel?.textColor = Toast.appearance.textColor
        textLabel?.numberOfLines = 0
        textLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addSubview(textLabel!)
    }
    
    override func updateConstraints() {
        if !constraintsSet {
            let padding = Toast.appearance.padding
            
            var views: [String: AnyObject] = ["label": textLabel!]
            
            let horizontalMargin = NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(padding)-[label]-\(padding)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            let verticalMargin = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(padding)-[label]-\(padding)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            
            self.addConstraints(horizontalMargin)
            self.addConstraints(verticalMargin)
            
            if blurEffectView != nil {
                views["blur"] = blurEffectView!
                
                let blurWidthConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[blur]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
                let blurHeightContraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[blur]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
                
                self.addConstraints(blurWidthConstraint)
                self.addConstraints(blurHeightContraint)
            }
            
            constraintsSet = true
        }
        
        super.updateConstraints()
    }
}