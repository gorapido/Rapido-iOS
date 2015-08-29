//
//  CalendarTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/11/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CalendarTableViewController: UITableViewController, HomeViewControllerProtocol {
  
  var userId: String?
  var jobs: JSON = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    // Bar Buttons
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: self, action: "showMenu:")
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newJob:")
    
    // Load Appointments
    if let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String {
      self.userId = userId
      
      Alamofire.request(.GET, "http://localhost:3000/v1/users/\(userId)/jobs").responseJSON {
        (req, res, data, err) in
        
        if err == nil {
          self.jobs = JSON(data!)
          
          self.tableView.reloadData()
        }
        else {
          
        }
      }
    }
    else {
      let homeViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
      
      homeViewController.delegate = self
      
      presentViewController(homeViewController, animated: false, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return jobs.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("job", forIndexPath: indexPath) as! UITableViewCell
  
    // Configure the cell...
    let format = NSDateFormatter()
    
    format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
    
    let start = format.dateFromString(jobs[indexPath.row]["start"].string!)
    
    let second = NSDateFormatter()
    
    second.dateStyle = .LongStyle
    second.timeStyle = .ShortStyle

    cell.textLabel?.text = second.stringFromDate(start!)
    cell.detailTextLabel?.text = jobs[indexPath.row]["category"].string
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
  
    return cell
  }
  
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
  }
  
  
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if editingStyle == .Delete {
      // Delete the row from the data source
      self.jobs.arrayObject?.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let project = indexPath.row
    
    performSegueWithIdentifier("BidsTableViewControllerSegue", sender: project)
  }
  
  func newJob(sender: UIBarButtonItem) {
    performSegueWithIdentifier("HireViewControllerSegue", sender: nil)
  }
  
  func showMenu(sender: UIBarButtonItem) {
    performSegueWithIdentifier("OptionsViewControllerSegue", sender: nil)
  }
  
  func homeViewControllerProtocolDidFinishHome(controller: HomeViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "BidsTableViewControllerSegue" {
      let bidsTableViewController = segue.destinationViewController as! BidsTableViewController
      
      let id = sender as! Int
      
      bidsTableViewController.project = jobs[id]
    }
  }
  
}
