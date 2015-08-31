//
//  SignUpViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit
import Alamofire
import SSKeychain
import SwiftyJSON
import SwiftValidator

protocol SignUpViewControllerProtocol {
  func signUpViewController(controller: SignUpViewController, didSignUpUser userId: String)
  func signUpViewControllerDidCancelSignUp(controller: SignUpViewController)
}

class SignUpViewController: UIViewController, ValidationDelegate {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var delegate: SignUpViewControllerProtocol?
  
  let validator = Validator()
  
  var firstNameTextField: UITextField?
  var lastNameTextField: UITextField?
  var phoneTextField: UITextField?
  var emailTextField: UITextField?
  var passwordTextField: UITextField?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    scrollView.width = view.width
    
    // Blue
    let blue = UIColor(hexString: "#106AAA")
    
    scrollView.backgroundColor = blue
    
    // Exit
    let exit = UIImage(named: "X")
    
    let exitBox = MGBox(size: CGSizeMake(view.width / 12, exit!.size.height))
    
    exitBox.topMargin = view.height / 24
    exitBox.leftMargin = 8
    
    let exitButton = UIButton(frame: exitBox.frame)
    
    exitButton.setImage(exit, forState: UIControlState.Normal)
    exitButton.onControlEvent(UIControlEvents.TouchUpInside) { action in
      self.delegate?.signUpViewControllerDidCancelSignUp(self)
    }
    
    exitBox.addSubview(exitButton)
    
    scrollView.boxes.addObject(exitBox)
    
    // Logo
    let logo = UIImage(named: "Rapido")
    
    let logoBox = MGBox(size: CGSizeMake(view.width, logo!.size.width))
    
    let logoView = UIImageView(frame: logoBox.frame)
    
    logoView.image = logo
    
    logoBox.addSubview(logoView)
    
    scrollView.boxes.addObject(logoBox)
    
    // First Name
    let firstNameBox = MGBox(size: CGSizeMake(view.width / 2, 32))
    
    //firstNameBox.topMargin = 64
    firstNameBox.bottomMargin = 8
    firstNameBox.backgroundColor = UIColor.whiteColor()
    
    firstNameTextField = UITextField(frame: firstNameBox.frame)
    
    firstNameTextField!.width = view.width / 2 - 16
    firstNameTextField!.center = firstNameBox.center
    firstNameTextField!.backgroundColor = UIColor.whiteColor()
    firstNameTextField!.placeholder = "jon"
    
    validator.registerField(firstNameTextField!, rules: [RequiredRule()])
    
    firstNameBox.addSubview(firstNameTextField!)
    
    scrollView.boxes.addObject(firstNameBox)
    
    let lastNameBox = MGBox(size: CGSizeMake(view.width / 2, 32))
    
    //lastNameBox.topMargin = 64
    lastNameBox.bottomMargin = 8
    lastNameBox.backgroundColor = UIColor.whiteColor()
    
    // Last Name
    lastNameTextField = UITextField(frame: firstNameBox.frame)
    
    lastNameTextField!.width = view.width / 2 - 16
    lastNameTextField!.center = lastNameBox.center
    lastNameTextField!.backgroundColor = UIColor.whiteColor()
    lastNameTextField!.placeholder = "doe"
    
    validator.registerField(lastNameTextField!, rules: [RequiredRule()])
    
    lastNameBox.addSubview(lastNameTextField!)
    
    scrollView.boxes.addObject(lastNameBox)
    
    // Phone
    let phoneBox = MGBox(size: CGSizeMake(view.width, 32))
    
    phoneBox.bottomMargin = 8
    phoneBox.backgroundColor = UIColor.whiteColor()
    
    phoneTextField = UITextField(frame: phoneBox.frame)
    
    phoneTextField!.width = view.width - 16
    phoneTextField!.center = phoneBox.center
    phoneTextField!.placeholder = "nnn-nnn-nnnn"
    phoneTextField!.backgroundColor = UIColor.whiteColor()
    
    validator.registerField(phoneTextField!, rules: [RequiredRule(), MinLengthRule(length: 9)])
    
    phoneBox.addSubview(phoneTextField!)
    
    scrollView.boxes.addObject(phoneBox)
    
    // Email
    let emailBox = MGBox(size: CGSizeMake(view.width, 32))
    
    emailBox.bottomMargin = 8
    emailBox.backgroundColor = UIColor.whiteColor()
    
    emailTextField = UITextField(frame: emailBox.frame)
    
    emailTextField!.width = view.width - 16
    emailTextField!.center = emailBox.center
    emailTextField!.placeholder = "john@doe.com"
    emailTextField!.backgroundColor = UIColor.whiteColor()
    
    validator.registerField(emailTextField!, rules: [RequiredRule(), EmailRule()])
    
    emailBox.addSubview(emailTextField!)
    
    scrollView.boxes.addObject(emailBox)
    
    // Password
    let passwordBox = MGBox(size: CGSizeMake(view.width, 32))
    
    passwordBox.bottomMargin = 8
    passwordBox.backgroundColor = UIColor.whiteColor()
    
    passwordTextField = UITextField(frame: passwordBox.frame)
    
    passwordTextField!.width = view.width - 16
    passwordTextField!.center = passwordBox.center
    passwordTextField!.placeholder = "password"
    passwordTextField!.backgroundColor = UIColor.whiteColor()
    passwordTextField!.secureTextEntry = true
    
    validator.registerField(passwordTextField!, rules: [RequiredRule(), MinLengthRule(length: 6)])
    
    passwordBox.addSubview(passwordTextField!)
    
    scrollView.boxes.addObject(passwordBox)
    
    // Submit
    let submitBox = MGBox(size: CGSizeMake(view.width, 32))
    
    let submitButton = UIButton(frame: submitBox.frame)
    
    submitButton.setTitle("Sign Up", forState: .Normal)
    // submitButton.backgroundColor = UIColor.whiteColor()
    submitButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      self.validator.validate(self)
    }
    
    submitBox.addSubview(submitButton)
    
    scrollView.boxes.addObject(submitBox)
    
    scrollView.layoutWithDuration(0.3, completion: { () -> Void in
      
    });
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func validationSuccessful() {
    let parameters = [
      "first_name": self.firstNameTextField!.text,
      "last_name": self.lastNameTextField!.text,
      "phone": self.phoneTextField!.text,
      "email": self.emailTextField!.text,
      "password": self.passwordTextField!.text
    ]
    
    Alamofire.request(Method.POST, "http://localhost:3000/v1/users", parameters: parameters)
      .responseJSON { req, res, data, err in
        if err == nil {
          let user = JSON(data!)
          
          let userId = user["id"].stringValue as String
          
          NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userid")
          NSUserDefaults.standardUserDefaults().setObject(self.emailTextField!.text, forKey: "username")
          SSKeychain.setPassword(self.passwordTextField!.text, forService: "Rapido", account: "co.rapido.rapido")
          
          self.delegate?.signUpViewController(self, didSignUpUser: userId)
        }
        else {
          let alert = UIAlertController(title: "Oops!", message: "It looks like something went wrong. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
        }
    }
  }
  
  func validationFailed(errors: [UITextField : ValidationError]) {
    let alert = UIAlertController(title: "Oops!", message: "It looks like you left something blank. Please fill everything in.", preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    
    self.presentViewController(alert, animated: true, completion: nil)

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
