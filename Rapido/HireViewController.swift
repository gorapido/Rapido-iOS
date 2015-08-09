//
//  HireViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/18/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices
import XLForm
import Alamofire

class HireViewController: XLFormViewController, HomeViewControllerProtocol {
  
  var userId: String?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Hire")
    
    let detailsSection = XLFormSectionDescriptor()
    
    form.addFormSection(detailsSection)
    
    let category = XLFormRowDescriptor(tag: "category", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Category")
    
    category.selectorOptions = ["Plumbing", "Electrical", "Air & Heating", "Massage", "Computer Assistance & Repair", "Web Development", "Mobile App Development", "Other"]
    
    category.required = true
    
    let other = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeText, title: "What?")
    
    other.required = true
    other.hidden = "NOT $category.value contains 'Other'"
    
    let _where = XLFormRowDescriptor(tag: "where", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Where")
    
    _where.selectorOptions = []
    _where.required = true
    
    let when = XLFormRowDescriptor(tag: "when", rowType: XLFormRowDescriptorTypeSelectorPush, title: "When")
    
    when.selectorOptions = ["Now", "Later"]
    when.required = true
    
    let start = XLFormRowDescriptor(tag: "start", rowType: XLFormRowDescriptorTypeDateTime, title: "Date & Time")
    
    start.required = true
    start.hidden = "NOT $when.value contains 'Later'"
    
    let problem = XLFormRowDescriptor(tag: "problem", rowType: XLFormRowDescriptorTypeTextView, title: nil)
    
    problem.cellConfigAtConfigure["textView.placeholder"] = "What's the problem?"
    problem.required = true
    
    detailsSection.addFormRow(category)
    detailsSection.addFormRow(other)
    detailsSection.addFormRow(_where)
    detailsSection.addFormRow(when)
    detailsSection.addFormRow(start)
    detailsSection.addFormRow(problem)
    
    let submitSection = XLFormSectionDescriptor()
    
    form.addFormSection(submitSection)
    
    let submit = XLFormRowDescriptor(tag: "submit", rowType: XLFormRowDescriptorTypeButton, title: "Submit")
    
    submit.action.formSelector = "didTouchSubmit:"
    
    submitSection.addFormRow(submit)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    if let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String {
      self.userId = userId
    }
    else {
      let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
      
      homeViewController.delegate = self
      
      presentViewController(homeViewController, animated: false, completion: nil)
    }
    
    let lightGray = UIColor(red: 0xCC, green: 0xCC, blue: 0xCC, alpha: 1)
    
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: lightGray], forState: .Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
    
    for item in tabBarController!.tabBar.items as! [UITabBarItem] {
      if let image = item.image {
        item.image = image.imageWithRenderingMode(.AlwaysOriginal)
      }
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    /*if user == nil {
      user = PFUser.currentUser()
    }*/
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender), animated: true)
    
    if formValidationErrors().count == 0 {
      var category = formValues()!["category"]!.valueData() as! String
      
      if category == "Other" {
        category = formValues()!["start"] as! String
      }
      
      var date = formValues()?["start"] as? NSDate
      
      if date == nil {
        date = NSDate()
      }
      
      let dateFormatter = NSDateFormatter()
      
      dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
      
      let start = dateFormatter.stringFromDate(date!)
      
      let summary = formValues()!["problem"]!.valueData() as! String
      
      let job = [
        "category": category,
        "start": start,
        "summary": summary
      ]
      
      Alamofire.request(.POST, "http://localhost:3000/v1/jobs", parameters: job).responseJSON {
        (req, res, data, err) in
        
        if err === nil {
          self.form.formRowWithTag("category").value = nil
          self.form.formRowWithTag("other").value = nil
          self.form.formRowWithTag("start").value = nil
          self.form.formRowWithTag("when").value = nil
          self.form.formRowWithTag("problem").value = nil
          
          self.tableView.reloadData()
          
          let alert = UIAlertController(title: "Sent!", message: "Your work request has been sent. Someone will in touch, shortly.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
          let alert = UIAlertController(title: "Darn!", message: "Something went wrong. Please try submitting again.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
    else {
      let alert = UIAlertController(title: "Error!", message: "It looks like you left something blank. Make sure everything is filled in.", preferredStyle: UIAlertControllerStyle.Alert)
        
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        
      presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  func homeViewControllerProtocolDidFinishHome(controller: HomeViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
