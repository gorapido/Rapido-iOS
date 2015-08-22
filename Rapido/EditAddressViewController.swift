//
//  EditAddressViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/22/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import XLForm
import Alamofire
import SwiftyJSON

class EditAddressViewController: XLFormViewController {
  
  var addressId: String?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor()
    
    let addressSection = XLFormSectionDescriptor()
    
    form.addFormSection(addressSection)
    
    let street = XLFormRowDescriptor(tag: "street", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    street.cellConfigAtConfigure["textField.placeholder"] = "Street"
    
    street.required = true
    
    let city = XLFormRowDescriptor(tag: "city", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    city.cellConfigAtConfigure["textField.placeholder"] = "City"
    
    city.required = true
    
    let state = XLFormRowDescriptor(tag: "state", rowType: XLFormRowDescriptorTypeText, title: "State")
    
    state.cellConfigAtConfigure["textField.placeholder"] = "State"
    
    //state.required = true
    state.disabled = true
    state.value = "FL"
    
    let postalCode = XLFormRowDescriptor(tag: "postalCode", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    postalCode.cellConfigAtConfigure["textField.placeholder"] = "Postal Code"
    
    postalCode.required = true
    
    addressSection.addFormRow(street)
    addressSection.addFormRow(city)
    addressSection.addFormRow(state)
    addressSection.addFormRow(postalCode)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if addressId == nil {
      title = "New Address"
    }
    else {
      Alamofire.request(.GET, "http://localhost:3000/v1/addresses/" + addressId!).responseJSON {
        (req, res, data, err) in
      
        if err == nil {
          let address = JSON(data!)
        
          self.form.formRowWithTag("street")!.value = address["street"].string
          self.form.formRowWithTag("city")!.value = address["city"].string
          self.form.formRowWithTag("postalCode")!.value = address["postal_code"].string
          
          self.tableView.reloadData()
        }
        else {
          
        }
      }
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "validateForm:")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func validateForm(button: UIBarButtonItem) {
    if formValidationErrors().count == 0 {
      let address = [
        "street": formValues()!["street"] as! String,
        "city": formValues()!["city"] as! String,
        "state": "FL",
        "postal_code": formValues()!["postalCode"] as! String
      ]
      
      if addressId == nil {
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as! String
        
        Alamofire.request(.POST, "http://localhost:3000/v1/users/" + userId + "/addresses", parameters: address).responseJSON {
          (req, res, data, err) in
          
          if err == nil {
            self.navigationController?.popToRootViewControllerAnimated(true)
          }
          else {
            
          }
        }
      }
      else {
        Alamofire.request(Method.PATCH, "http://localhost:3000/v1/addresses/" + addressId!, parameters: address).responseJSON {
          (req, res, data, err) in
          
          if err == nil {
            self.navigationController?.popToRootViewControllerAnimated(true)
          }
          else {
            
          }
        }
      }
    }
    else {
      let alert = UIAlertController(title: "Error!", message: "It looks like you left something blank. Make sure everything is filled in.", preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
      
      presentViewController(alert, animated: true, completion: nil)
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
