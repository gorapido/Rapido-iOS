//
//  MessageTableViewCell.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/29/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
  
  var kAvatarSize = 30.0
  var kMinimumHeight = 50.0
  
  private var _titleLabel: UILabel?
  private var _bodyLabel: UILabel?
  private var _thumbnailView: UIImageView?
  private var _attachmentView: UIImageView?
  
  var indexPath: NSIndexPath?

  var usedForMessage: Bool?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .None
    backgroundColor = UIColor.whiteColor()
    
    contentView.addSubview(titleLabel)
    contentView.addSubview(bodyLabel)
    contentView.addSubview(thumbnailView)
    contentView.addSubview(attachmentView)
    
    let views: NSDictionary = [
      "titleLabel": _titleLabel!,
      "bodyLabel": _bodyLabel!,
      "thumbnailView": _thumbnailView!,
      "attachmentView": _attachmentView!
    ]
    
    let metrics: NSDictionary = [
      "tumbSize": kAvatarSize,
      "trailing": 10,
      "leading": 5,
      "attchSize": 80
    ]
    
    // Horizontal
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-leading-[thumbnailView(tumbSize)]-trailing-[titleLabel(>=0)]-trailing-|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject]))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-leading-[thumbnailView(tumbSize)]-trailing-[bodyLabel(>=0)]-trailing-|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject]))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-leading-[thumbnailView(tumbSize)]-trailing-[attachmentView]-trailing-|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject]))
    
    // Vertical
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-trailing-[thumbnailView(tumbSize)]-(>=0)-|", options: nil, metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject]))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[titleLabel]-leading-[bodyLabel(>=0)]-leading-[attachmentView(>=0,<=attchSize)]-trailing-|", options: NSLayoutFormatOptions(0), metrics: metrics as [NSObject : AnyObject], views: views as [NSObject : AnyObject]))
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    selectionStyle = .None
    
    titleLabel.font = UIFont.boldSystemFontOfSize(16)
    bodyLabel.font = UIFont.systemFontOfSize(16)
    attachmentView.image = nil
  }

  // Getters
  
  var titleLabel: UILabel {
    get {
      if _titleLabel == nil {
        _titleLabel = UILabel()
        
        _titleLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        _titleLabel?.backgroundColor = UIColor.clearColor()
        _titleLabel?.userInteractionEnabled = false
        _titleLabel?.numberOfLines = 0
        
        _titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        _titleLabel?.textColor = UIColor.grayColor()
      }
      
      return _titleLabel!
    }
  }
  
  var bodyLabel: UILabel {
    get {
      if _bodyLabel == nil {
        _bodyLabel = UILabel()
        
        _bodyLabel?.setTranslatesAutoresizingMaskIntoConstraints(false)
        _bodyLabel?.backgroundColor = UIColor.clearColor()
        _bodyLabel?.userInteractionEnabled = false
        _bodyLabel?.numberOfLines = 0
        
        _bodyLabel?.font = UIFont.boldSystemFontOfSize(16)
        _bodyLabel?.textColor = UIColor.darkGrayColor()
      }
      
      return _bodyLabel!
    }
  }
  
  var thumbnailView: UIImageView {
    get {
      if _thumbnailView == nil {
        _thumbnailView = UIImageView()
        
        _thumbnailView?.setTranslatesAutoresizingMaskIntoConstraints(false)
        _thumbnailView?.userInteractionEnabled = false
        _thumbnailView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        _thumbnailView?.layer.cornerRadius = CGFloat(kAvatarSize) / 2.0
        _thumbnailView?.layer.masksToBounds = true
      }
      
      return _thumbnailView!
    }
  }
  
  var attachmentView: UIImageView {
    get {
      _attachmentView = UIImageView()
      
      _attachmentView?.setTranslatesAutoresizingMaskIntoConstraints(false)
      _attachmentView?.userInteractionEnabled = false
      _attachmentView?.backgroundColor = UIColor.clearColor()
      _attachmentView?.contentMode = .Center
      
      _attachmentView?.layer.cornerRadius = CGFloat(kAvatarSize) / 4.0
      _attachmentView?.layer.masksToBounds = true
      
      return _attachmentView!
    }
  }
  
  var needsPlaceholder: Bool {
    get {
      return (_thumbnailView?.image == nil) ? true : false
    }
  }
  
}
