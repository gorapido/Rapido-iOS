//
//  ReviewViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 9/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import XLForm
import Alamofire
import SwiftyJSON

class ReviewViewController: XLFormViewController {
  
  var project: JSON?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    initializeForm()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
   
    initializeForm()
  }
  
  func initializeForm() {
    let form = XLFormDescriptor()
    
    let mainSection = XLFormSectionDescriptor()
    
    form.addFormSection(mainSection)
    
    // Rating
    let rating = XLFormRowDescriptor(tag: "rating", rowType: XLFormRowDescriptorTypeRate, title: "Rating")
    
    rating.required = true
    rating.value = 3
    
    mainSection.addFormRow(rating)
    
    // Summary
    let summary = XLFormRowDescriptor(tag: "summary", rowType: XLFormRowDescriptorTypeTextView)
    
    summary.cellConfigAtConfigure["textView.placeholder"] = "How was your sevice?"
    
    mainSection.addFormRow(summary)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveReview:")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func saveReview(sender: UIBarButtonItem) {
    let projectId = project!["id"].stringValue as String
    
    let companyId = project!["companyId"].stringValue as String
    
    let userId = project!["userId"].stringValue as String
    
    let rating = formValues()!["rating"]!.valueData() as! Double
    
    let ratingStr = String(format: "%d", Int(rating))
    
    let summary = formValues()!["summary"]!.valueData() as! String
    
    let parameters = [
      "jobId": projectId,
      "companyId": companyId,
      "userId": userId,
      "rating": ratingStr,
      "summary": summary
    ]
    
    Alamofire.request(.POST, "\(Globals.BASE_URL)/reviews?token=\(Globals.API_TOKEN)", parameters: parameters).responseJSON {
      (req, res, data, err) in
      
      let alert = UIAlertController(title: "Submitted!", message: "Your review has been submitted for others to see.", preferredStyle: .Alert)
      
      alert.addAction(UIAlertAction(title: "Okay", style: .Default) {
        (action) in
        
        self.navigationController?.popToRootViewControllerAnimated(true)
      })
      
      self.presentViewController(alert, animated: true, completion: nil)
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
