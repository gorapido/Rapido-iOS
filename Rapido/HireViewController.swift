//
//  HireViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/18/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation
import XLForm
import Alamofire
import SwiftyJSON

class HireViewController: XLFormViewController, CLLocationManagerDelegate {
  
  var userId: String?
  
  let locationManager = CLLocationManager()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Hire")
    
    // Details Section
    
    let detailsSection = XLFormSectionDescriptor()
    
    form.addFormSection(detailsSection)
    
    // Category
    
    let category = XLFormRowDescriptor(tag: "category", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Category")
    
    category.selectorOptions = ["Plumbing", "Electrical", "Air & Heating", "Roofing",  "Lawn", "Massage", "Computer Assistance & Repair", "Web Development", "Mobile App Development", "Other"]
    
    category.required = true
    
    detailsSection.addFormRow(category)
    
    // Other
    
    let other = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeText, title: "What?")
    
    other.required = true
    other.hidden = "NOT $category.value contains 'Other'"
    
    detailsSection.addFormRow(other)
    
    // Where
    
    let _where = XLFormRowDescriptor(tag: "where", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Where")
    
    // _where.selectorOptions = ["Here"]
    _where.required = true
    
    detailsSection.addFormRow(_where)
    
    // When
    
    let when = XLFormRowDescriptor(tag: "when", rowType: XLFormRowDescriptorTypeSelectorPush, title: "When")
    
    when.selectorOptions = ["Now", "Later"]
    when.required = true
    
    detailsSection.addFormRow(when)
    
    // Start
    
    let start = XLFormRowDescriptor(tag: "start", rowType: XLFormRowDescriptorTypeDateTime, title: "Date & Time")
    
    start.required = true
    start.hidden = "NOT $when.value contains 'Later'"
    
    detailsSection.addFormRow(start)
    
    // Problem
    
    let problem = XLFormRowDescriptor(tag: "problem", rowType: XLFormRowDescriptorTypeTextView, title: nil)
    
    problem.cellConfigAtConfigure["textView.placeholder"] = "What's the problem?"
    problem.required = true
    
    detailsSection.addFormRow(problem)
    
    // Submit Section
    
    let submitSection = XLFormSectionDescriptor()
    
    form.addFormSection(submitSection)
    
    // Submit
    
    let submit = XLFormRowDescriptor(tag: "submit", rowType: XLFormRowDescriptorTypeButton, title: "Submit")
    
    submit.action.formSelector = "didTouchSubmit:"
    
    submitSection.addFormRow(submit)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
      
    switch CLLocationManager.authorizationStatus() {
    case .NotDetermined:
      locationManager.requestWhenInUseAuthorization()
      break
    case .AuthorizedWhenInUse:
      locationManager.startUpdatingLocation()
      break
    case .Restricted, .Denied:
      let alert = UIAlertController(
        title: "Background Location Access Disabled",
        message: "In order to be find service providers near you, please open Rapido's app settings and set location access to 'When Using the App'.",
        preferredStyle: .Alert)
        
      let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
      alert.addAction(cancel)
        
      let open = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
          UIApplication.sharedApplication().openURL(url)
        }
      }
        
      alert.addAction(open)
        
      presentViewController(alert, animated: true, completion: nil)
      break
    default:
      break
    }
      
    if let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String {
      self.userId = userId
      
      Alamofire.request(.GET, "http://localhost:3000/v1/users/\(userId)/addresses").responseJSON {
        (req, res, data, err) in
        
        let json = JSON(data!)
        
        var addresses: [AnyObject] = [XLFormOptionsObject(value: "here", displayText: "Here")]
        
        for (index: String, subJSON: JSON) in json {
          let address = subJSON["street"].string
          
          addresses.append(XLFormOptionsObject(value: subJSON["id"].string, displayText: address!))
        }
        
        self.form.formRowWithTag("where")!.selectorOptions = addresses as [AnyObject]
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender)!, animated: true)
    
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
      
      let addressId = formValues()!["where"]!.valueData() as! String
      
      var job = [
        "category": category,
        "start": start,
        "summary": summary,
        "userId": userId!
      ]
      println(job)
      if addressId == "here" {
        // job["coordinate"] = "{ \"latitude\": \(locationManager.location.coordinate.latitude), \"longitude\": \(locationManager.location.coordinate.longitude) }"
      }
      else {
        job["addressId"] = addressId
      }
      
      Alamofire.request(.POST, "http://localhost:3000/v1/jobs", parameters: job).responseJSON {
        (req, res, data, err) in
        
        if err === nil {
          self.form.formRowWithTag("category")!.value = nil
          self.form.formRowWithTag("other")!.value = nil
          self.form.formRowWithTag("start")!.value = nil
          self.form.formRowWithTag("where")!.value = nil
          self.form.formRowWithTag("when")!.value = nil
          self.form.formRowWithTag("problem")!.value = nil
          
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
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
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
