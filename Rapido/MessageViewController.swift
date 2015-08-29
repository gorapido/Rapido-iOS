//
//  ChatViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/24/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import SlackTextViewController

class MessageViewController: SLKTextViewController {
  
  let kAvatarSize = CGFloat(30.0)
  let kMinimumHeight = CGFloat(50.0)
  
  var messages = NSMutableArray()
  
  override init!(tableViewStyle style: UITableViewStyle) {
    super.init(tableViewStyle: .Plain)
    
    common()
  }

  required init!(coder decoder: NSCoder!) {
    super.init(coder: decoder)
    
    common()
  }
  
  private func common() {
    registerClassForTextView(MessageTextView.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.bounces = true
    self.shakeToClearEnabled = true
    self.keyboardPanningEnabled = true
    self.inverted = true
    
    self.textView.placeholder = "Message"
    self.textView.placeholderColor = UIColor.lightGrayColor()
    
    self.typingIndicatorView.canResignByTouch = true
    
    tableView.separatorStyle = .None
    tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "Message")
    
    rightButton.setTitle("Send", forState: .Normal)
    
    textInputbar.autoHideRightButton = true
    textInputbar.maxCharCount = 140
    textInputbar.counterStyle = .Split
    textInputbar.counterPosition = .Top
    
    typingIndicatorView.canResignByTouch = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func didPressRightButton(sender: AnyObject!) {
    textView.refreshFirstResponder()
    
    let message = Message()
    
    message.username = "John Q. Public"
    message.text = textView.text
    
    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
    let rowAnimation = inverted ? UITableViewRowAnimation.Bottom : UITableViewRowAnimation.Top
    let scrollPosition = inverted ? UITableViewScrollPosition.Bottom : UITableViewScrollPosition.Top
    
    tableView.beginUpdates()
    
    messages.insertObject(message, atIndex: 0)
    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
    
    tableView.endUpdates()
    
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: scrollPosition, animated: true)
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
   
    super.didPressRightButton(sender)
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Message") as! MessageTableViewCell
    let message = messages[indexPath.row] as! Message
    println(indexPath.row)
    cell.titleLabel.text = message.username?.copy() as? String
    cell.bodyLabel.text = message.text?.copy() as? String
    
    cell.usedForMessage = true
    
    cell.indexPath = indexPath
    
    cell.transform = tableView.transform
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let message = messages[indexPath.row] as! Message
    
    let paragraphStyle = NSMutableParagraphStyle()
    
    paragraphStyle.lineBreakMode = .ByWordWrapping
    paragraphStyle.alignment = .Left
    
    let attributes = [
      NSFontAttributeName: UIFont.systemFontOfSize(16.0),
      NSParagraphStyleAttributeName: paragraphStyle
    ]
    
    var width = CGRectGetWidth(tableView.frame) - kAvatarSize
    
    width = width - 25.0
    
    let titleBounds = message.username?.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
    
    let bodyBounds = message.text?.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
    
    if message.text!.length == 0 {
      return 0.0
    }
    
    var height = CGRectGetHeight(titleBounds!)
    
    height = height + CGRectGetHeight(bodyBounds!)
    height = height + 40.0
    
    if let attachment = message.attachment {
      height += 80.0 + 10.0
    }
    
    if height < kMinimumHeight {
      height = kMinimumHeight
    }
    
    return height
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
