//
//  JobViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit
import Alamofire
import SwiftyJSON

class JobViewController: UIViewController {
  
  var job: JSON?
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    // Employee Name
    /* let employeeName = MGBox(size: CGSizeMake(view.width, 32))
    
    let employeeNameLabel = UILabel(frame: employeeName.frame)
    
    employeeNameLabel.text = "Joe Bob"
    
    employeeName.addSubview(employeeNameLabel)
    
    scrollView.boxes.addObject(employeeName) */
    
    // Company Name
    let companyName = MGBox(size: CGSizeMake(view.width, 32))
    
    let companyNameLabel = UILabel(frame: companyName.frame)
    
    companyNameLabel.text = "Joe's Plumbing"
    
    companyName.addSubview(companyNameLabel)
    
    scrollView.boxes.addObject(companyName)
    
    // Start
    let start = MGBox(size: CGSizeMake(view.width, 32))
    
    let startLabel = UILabel(frame: start.frame)
    
    let format = NSDateFormatter()
    
    format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    
    let startStr = format.dateFromString(job!["start"].string!)
    
    let second = NSDateFormatter()
    
    second.dateStyle = .LongStyle
    second.timeStyle = .ShortStyle
    
    startLabel.text = second.stringFromDate(startStr!)
    
    start.addSubview(startLabel)
    
    scrollView.boxes.addObject(start)
    
    // Location
    let location = MGBox(size: CGSizeMake(view.width, 32))
    
    let locationLabel = UILabel(frame: start.frame)
    
    var locationString = "Here"
    
    if job!["addresses"].count > 0 {
      let address = job!["addresses"][0]
      
      locationString = address["street"].string! + " " + address["city"].string! + ", " + address["state"].string! + " " + address["postal_code"].string!
    }
    else if job!["coordinates"].count > 0 {
      let coordinate = job!["coordinates"][0]
      
      let latitude = coordinate["latitude"].float
      
      let longitude = coordinate["longitude"].float
      
      locationString = "\(latitude!), \(longitude!)"
    }
    
    locationLabel.text = locationString
    
    location.addSubview(locationLabel)
    
    scrollView.boxes.addObject(location)
    
    // Category
    let category = MGBox(size: CGSizeMake(view.width, 32))
    
    let categoryLabel = UILabel(frame: start.frame)
    
    categoryLabel.text = job!["category"].string
    
    category.addSubview(categoryLabel)
    
    scrollView.boxes.addObject(category)
    
    // Phone
    let phone = MGBox(size: CGSizeMake(view.width, 32))
    
    let phoneButton = UIButton(frame: start.frame)
    
    phoneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    phoneButton.setTitle("407-844-7695", forState: .Normal)
    
    phone.addSubview(phoneButton)
    
    scrollView.boxes.addObject(phone)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    scrollView.layoutWithDuration(0.3, completion: { () -> Void in
      
    });
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
