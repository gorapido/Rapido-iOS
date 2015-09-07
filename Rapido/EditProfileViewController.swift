//
//  ProfileFormViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import XLForm
import Alamofire
import SwiftyJSON

class EditProfileViewController: XLFormViewController {
  
  var userId: String?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Edit Profile")
    
    /*let avatarSection = XLFormSectionDescriptor()
    
    form.addFormSection(avatarSection)
    
    let avatar = XLFormRowDescriptor(tag: "avatar", rowType: XLFormRowDescriptorTypeButton, title: "Avatar")
    
    avatarSection.addFormRow(avatar)*/
    
    let personalSection: XLFormSectionDescriptor = XLFormSectionDescriptor()
    
    form.addFormSection(personalSection)
    
    let firstName = XLFormRowDescriptor(tag: "firstName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    firstName.cellConfigAtConfigure["textField.placeholder"] = "first name"
    firstName.required = true
    
    let lastName = XLFormRowDescriptor(tag: "lastName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    lastName.cellConfigAtConfigure["textField.placeholder"] = "last name"
    lastName.required = true
    
    let email = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeEmail, title: nil)
    
    email.cellConfigAtConfigure["textField.placeholder"] = "email"
    email.addValidator(XLFormValidator.emailValidator())
    email.required = true
    email.disabled = true
    
    let phone = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: nil)
    
    phone.cellConfigAtConfigure["textField.placeholder"] = "phone"
    phone.addValidator(XLFormRegexValidator(msg: "Must be a valid phone number!", regex: "\\+?1?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$"))
    phone.required = true
    
    personalSection.addFormRow(firstName)
    personalSection.addFormRow(lastName)
    personalSection.addFormRow(email)
    personalSection.addFormRow(phone)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "validateForm:")
    
    userId = NSUserDefaults.standardUserDefaults().objectForKey("userid") as? String
    
    Alamofire.request(.GET, "\(Globals.BASE_URL)/users/\(userId!)?token=\(Globals.API_TOKEN)").responseJSON {
      (req, res, data, err) in
      
      if err == nil {
        let user = JSON(data!)
      
        self.form.formRowWithTag("firstName")!.value = user["first_name"].string
        self.form.formRowWithTag("lastName")!.value = user["last_name"].string
        self.form.formRowWithTag("email")!.value = user["email"].string
        self.form.formRowWithTag("phone")!.value = user["phone"].string
        
        self.tableView.reloadData()
      }
      else {
        println(err)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func validateForm(button: UIBarButtonItem) {
    if formValidationErrors().count == 0 {
      let user = [
        "first_name": formValues()!["firstName"] as! String,
        "last_name": formValues()!["lastName"] as! String,
        "phone": formValues()!["phone"] as! String
      ]
      
      Alamofire.request(.PATCH, "\(Globals.BASE_URL)/users/\(userId!)?token=\(Globals.API_TOKEN)", parameters: user).responseJSON {
        (req, res, data, err) in
        
        if err == nil {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else {
          let alert = UIAlertController(title: "Error!", message: "Something went wrong. Please try saving again.", preferredStyle: UIAlertControllerStyle.Alert)
          
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
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
