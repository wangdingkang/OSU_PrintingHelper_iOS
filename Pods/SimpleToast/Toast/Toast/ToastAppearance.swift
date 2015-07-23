//
//  ToastAppearance.swift
//  Toast
//
//  Created by Hannes Lohmander on 13/07/15.
//  Copyright (c) 2015 Lohmander. All rights reserved.
//

import Foundation

public class ToastAppearance {
    /// Whether or not the toast background should have a blurred background
    public var blur: Bool = true
    
    /// Blur style if blur is set to true
    public var blurStyle: UIBlurEffectStyle = .Dark
    
    /// Toast background corner radius
    public var cornerRadius: CGFloat = 4
    
    /// Margin between the toast and the surrounding view
    public var margin: CGFloat = 16
    
    /// Padding between the text label and the toast background
    public var padding: CGFloat = 10
    
    /// The label text color
    public var textColor: UIColor = UIColor.whiteColor()
    
    /// The duration of the fade in animation
    public var animationDuration: NSTimeInterval = 0.5
}
