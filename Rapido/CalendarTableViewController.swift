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

class CalendarTableViewController: UITableViewController {
  
  var userId: String?
  var jobs: JSON = []
  
  // lists
  
  var upcoming: JSON = []
  var past: JSON = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    let segmentedControl = UISegmentedControl(items: ["Upcoming", "Past"])
    
    segmentedControl.selectedSegmentIndex = 0
    
    segmentedControl.addTarget(self, action: "segmentedControlHasChangedValue:", forControlEvents: .ValueChanged)
    
    tableView.tableHeaderView = segmentedControl
    
    if let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String {
      self.userId = userId
      
      Alamofire.request(.GET, "http://localhost:3000/v1/users/\(userId)/jobs?filter=upcoming").responseJSON {
        (req, res, data, err) in
        
        if err == nil {
          let upcoming = JSON(data!)
          
          self.upcoming = upcoming
          self.jobs = upcoming
          
          self.tableView.reloadData()
        }
        else {
          
        }
      }
      
      Alamofire.request(.GET, "http://localhost:3000/v1/users/\(userId)/jobs?filter=past").responseJSON {
        (req, res, data, err) in
        
        if err == nil {
          let past = JSON(data!)
          
          self.past = past
          
          self.tableView.reloadData()
        }
        else {
          
        }
      }
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
  
  func segmentedControlHasChangedValue(sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      jobs = upcoming
    }
    else if sender.selectedSegmentIndex == 1 {
      jobs = past
    }
    
    tableView.reloadData()
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
    let job = indexPath.row
    
    performSegueWithIdentifier("JobViewControllerSegue", sender: job)
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
    let jobViewController = segue.destinationViewController as! JobViewController
    
    let row = sender as! Int
    
    jobViewController.job = jobs[row] as? JSON
  }
  
}
