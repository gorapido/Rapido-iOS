//
//  AddressesTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/9/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddressesTableViewController: UITableViewController {
  
  var addresses: JSON = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    let rightBarButton = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newAddress:")
    
    navigationItem.rightBarButtonItem = rightBarButton
    
    common()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    common()
  }
  
  func common() {
    let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String
    
    Alamofire.request(.GET, "\(Globals.BASE_URL)/users/\(userId!)/addresses?token=\(Globals.API_TOKEN)").responseJSON {
      (req, res, data, err) in
      let addresses = JSON(data!)
      
      if addresses.array!.count > 0 {
        self.addresses = addresses
        
        self.tableView.reloadData()
      }
      else {
        
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    /* if addresses.count == 0 {
      let messageLabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
      
      messageLabel.text = "You don't have any addresses yet."
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
    return addresses.count
  }
  
  func newAddress(sender: UIBarButtonItem) {
    performSegueWithIdentifier("EditAddressViewControllerSegue", sender: nil)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("address", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    cell.textLabel?.text = addresses[indexPath.row]["street"].string
    cell.detailTextLabel?.text = addresses[indexPath.row]["city"].string! + ", " + addresses[indexPath.row]["state"].string! + " " + addresses[indexPath.row]["postal_code"].string!
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
  
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let addressId = addresses[indexPath.row]["id"].string! as String
    
    performSegueWithIdentifier("EditAddressViewControllerSegue", sender: addressId)
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
      let addressId = addresses[indexPath.row]["id"].string! as String
      Alamofire.request(.DELETE, "\(Globals.BASE_URL)/addresses/\(addressId)?token=\(Globals.API_TOKEN)").responseJSON {
        (req, res, data, err) in
        
        if err == nil {
          self.addresses.arrayObject?.removeAtIndex(indexPath.row)
          self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        else {
          
        }
      }
    }
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
    
    if let addressId = sender as? String {
      let editAddressViewController = segue.destinationViewController as! EditAddressViewController
      
      editAddressViewController.addressId = addressId
    }
  }
  
}
