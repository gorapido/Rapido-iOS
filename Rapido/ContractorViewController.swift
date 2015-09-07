//
//  ContractorViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/24/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit
import Alamofire
import Cosmos
import SwiftyJSON
import Kingfisher

class ContractorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var tableView: UITableView?
  
  var contractorId: String?
  
  var project: JSON?
  
  var reviews: JSON = []
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if contractorId == project!["companyId"].string && project!["status"].string != "All done." {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", style: .Plain, target: self, action: "writeReview:")
    }
    
    if let companyId = project!["companyId"].string {
      
    }
    else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hire", style: .Plain, target: self, action: "hireContractor:")
    }
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    scrollView.width = view.width
    
    // Logo
    let logo = MGBox(size: CGSizeMake(view.width, 128))
    
    let logoImage = UIImageView(frame: logo.frame)
    
    logo.addSubview(logoImage)
    
    scrollView.boxes.addObject(logo)
    
    // Name
    let name = MGBox(size: CGSizeMake(view.width, 32))
    
    let nameLabel = UILabel(frame: name.frame)
    
    // nameLabel.text = "This A/C Co."
    nameLabel.textAlignment = .Center
    nameLabel.center = name.center
    
    name.addSubview(nameLabel)
    
    scrollView.boxes.addObject(name)
    
    // Location
    let location = MGBox(size: CGSizeMake(view.width / 3, 32))
    
    let locationButton = UIButton(frame: location.frame)
    
    // locationButton.setTitle("Orlando, FL", forState: .Normal)
    locationButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
    locationButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
    locationButton.center = location.center
    
    location.addSubview(locationButton)
    
    scrollView.boxes.addObject(location)
    
    // Site
    let site = MGBox(size: CGSizeMake(view.width / 3, 32))
    
    let siteButton = UIButton(frame: site.frame)
    
    // siteButton.setTitle("www.this.ac", forState: .Normal)
    siteButton.center = site.center
    siteButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
    siteButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
    siteButton.onControlEvent(UIControlEvents.TouchUpInside) { action in
      let alert = UIAlertController(title: "Open Safari?", message: nil, preferredStyle: .Alert)
      
      alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
      
      alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) in
        
        let website = siteButton.titleLabel!.text
        
        if let url = NSURL(string: website!) {
          UIApplication.sharedApplication().openURL(url)
        }
      })
      
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    site.addSubview(siteButton)
    
    scrollView.boxes.addObject(site)
    
    // Phone
    let call = MGBox(size: CGSizeMake(view.width / 3, 32))
    
    let callButton = UIButton(frame: call.frame)
    
    // callButton.setTitle("(407) 844-7695", forState: .Normal)
    callButton.center = site.center
    callButton.titleLabel?.font = UIFont.systemFontOfSize(16.0)
    callButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
    callButton.onControlEvent(UIControlEvents.TouchUpInside) { action in
      let alert = UIAlertController(title: "Make a call?", message: nil, preferredStyle: .Alert)
      
      alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
      
      alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) in
        
        let phone = siteButton.titleLabel!.text
        
        if let url = NSURL(string: "tel://\(phone)") {
          UIApplication.sharedApplication().openURL(url)
        }
      })
      
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    call.addSubview(callButton)
    
    scrollView.boxes.addObject(call)
    
    // Description
    let description = MGBox(size: CGSizeMake(view.width, 64))
    
    let descriptionText = UITextView(frame: description.frame)
    
    descriptionText.editable = false
    // descriptionText.text = "What's 75 feet long and doesn't exist?"
    
    description.addSubview(descriptionText)
    
    scrollView.boxes.addObject(description)
    
    // Average
    /* let rating = MGBox(size: CGSizeMake(view.width, 64))
    
    let ratingView = CosmosView()
    
    ratingView.rating = 5
    ratingView.text = "Average Rating"
    ratingView.center = rating.center
    ratingView.userInteractionEnabled = false
    
    rating.addSubview(ratingView)
    
    scrollView.boxes.addObject(rating) */
    
    // Reviews
    let reviews = MGBox(size: CGSizeMake(view.width, view.height / 2))
    
    tableView = UITableView(frame: reviews.frame)
    
    tableView!.delegate = self
    tableView!.dataSource = self
    tableView?.registerNib(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "review")
    
    reviews.addSubview(tableView!)
    
    scrollView.boxes.addObject(reviews)
    
    // Initialize
    scrollView.layoutWithDuration(0.3, completion: { () -> Void in
      
    });
    
    Alamofire.request(.GET, "\(Globals.BASE_URL)/companies/\(contractorId!)?token=\(Globals.API_TOKEN)").responseJSON {
      (req, res, data, err) in
      
      let contractor = JSON(data!)
      
      let logoSource = contractor["logo"].string
      
      logoImage.kf_setImageWithURL(NSURL(string: logoSource!)!)
      nameLabel.text = contractor["name"].string
      locationButton.setTitle(contractor["location"].string, forState: .Normal)
      siteButton.setTitle(contractor["site"].string, forState: .Normal)
      callButton.setTitle(contractor["phone"].string, forState: .Normal)
      descriptionText.text = contractor["description"].string
      
      self.reviews = contractor["reviews"]
      
      self.tableView?.reloadData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    /* if reviews == [] {
      let messageLabel = UILabel(frame: CGRectMake(0, 0, self.tableView!.bounds.size.width, self.tableView!.bounds.size.height))
      
      messageLabel.text = "Looks like they don't have any reviews yet."
      messageLabel.textAlignment = .Center
      messageLabel.sizeToFit()
      
      self.tableView!.backgroundView = messageLabel;
      self.tableView!.separatorStyle = .None;
      
      return 0
    } */
    
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("review") as! ReviewTableViewCell
    
    let review = reviews[indexPath.row]
    
    cell.authorLabel!.text = review["user"]["first_name"].string
    
    let rating = review["rating"].number
    
    let num = rating!.doubleValue
    
    cell.ratingView.rating = num
    cell.summaryText!.text = review["summary"].string
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 108
  }
  
  func hireContractor(sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Ready!", message: "Once you accept, this contractor will be contacting you.", preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
      action in
      
      let parameters = [
        "companyId": self.contractorId!,
        "status": "I hired someone."
      ]
      
      let projectId = self.project!["id"].string
      
      Alamofire.request(.PATCH, "\(Globals.BASE_URL)/jobs/\(projectId!)?token=\(Globals.API_TOKEN)", parameters: parameters)
        .responseJSON { (req, res, data, err) in
          self.navigationController?.popToRootViewControllerAnimated(true)
      }
    })
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func writeReview(sender: UIBarButtonItem) {
    performSegueWithIdentifier("ReviewViewControllerSegue", sender: nil)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    let reviewViewController = segue.destinationViewController as! ReviewViewController
    
    reviewViewController.project = self.project
  }
  
}
