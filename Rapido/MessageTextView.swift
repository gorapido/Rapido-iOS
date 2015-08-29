//
//  ChatViewCell.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/25/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import Foundation
import SlackTextViewController

class MessageTextView: SLKTextView {
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func willMoveToSuperview(newSuperview: UIView?) {
    super.willMoveToSuperview(newSuperview)
    
    self.backgroundColor = UIColor.whiteColor()
    
    self.placeholder = "Message"
    self.placeholderColor = UIColor.lightGrayColor()
    self.pastableMediaTypes = .All
    
    self.layer.borderColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0).CGColor
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.mainScreen().scale
  }
  
}
