//
//  BidsTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/24/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import SwiftyJSON

class BidsTableViewController: UITableViewController {
  
  var project: JSON?
  var contractors = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: "projectInfo:")
    
    let bids = project!["bids"]
    
    for (key: String, bid: JSON) in bids {
      let company: AnyObject = bid["company"].object
      
      contractors.addObject(company)
    }
    
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    /* if contractors == [] {
      let messageLabel = UILabel(frame: CGRectMake(0, 0,
        self.tableView.bounds.size.width,
        self.tableView.bounds.size.height))
      
      messageLabel.text = "No bids yet. We're still looking."
      messageLabel.textAlignment = .Center
      messageLabel.sizeToFit()
      
      self.tableView.backgroundView = messageLabel
      self.tableView.separatorStyle = .None
      
      return 0
    } */
    
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return contractors.count
  }
  
  func projectInfo(sender: UIBarButtonItem) {
    performSegueWithIdentifier("ProjectViewControllerSegue", sender: nil)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("company", forIndexPath: indexPath) as! UITableViewCell
  
    let contractor: AnyObject = contractors.objectAtIndex(indexPath.row)
    
    // Configure the cell...
    cell.textLabel!.text = contractor["name"] as? String
    
    let id = contractor["id"] as! String
    
    if (project!["companyId"].string == id) {
      cell.detailTextLabel!.text = "Hired"
      // cell.backgroundColor = UIColor.grayColor()
    }
    else {
      cell.detailTextLabel!.text = ""
    }
  
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let contractor: AnyObject = contractors[indexPath.row]
    
    performSegueWithIdentifier("ContractorViewControllerSegue", sender: contractor["id"])
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
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
    
    if segue.identifier == "ProjectViewControllerSegue" {
      let projectViewController = segue.destinationViewController as! ProjectViewController
      
      projectViewController.project = project
    }
    else if segue.identifier == "ContractorViewControllerSegue" {
      let contractorViewController = segue.destinationViewController as! ContractorViewController
      
      contractorViewController.contractorId = sender as? String
      
      contractorViewController.project = project
    }
  }
  
}
