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

protocol SignUpViewControllerProtocol {
  func signUpViewController(controller: SignUpViewController, didSignUpUser userId: String)
  func signUpViewControllerDidCancelSignUp(controller: SignUpViewController)
}

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var delegate: SignUpViewControllerProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    let blue = UIColor(hexString: "#106AAA")
    
    scrollView.backgroundColor = blue
    
    let exit = UIImage(named: "X")
    
    let exitBox = MGBox(size: CGSizeMake(exit!.size.width, exit!.size.height))
    
    exitBox.topMargin = view.height / 24
    // exitBox.leftMargin = 8
    
    let exitButton = UIButton(frame: exitBox.frame)
    
    exitButton.setImage(exit, forState: UIControlState.Normal)
    exitButton.onControlEvent(UIControlEvents.TouchUpInside) { action in
      self.delegate?.signUpViewControllerDidCancelSignUp(self)
    }
    
    exitBox.addSubview(exitButton)
    
    scrollView.boxes.addObject(exitBox)
    
    let bufferBox = MGBox(size: CGSizeMake(view.width - exit!.size.width, exit!.size.height))
    
    bufferBox.topMargin = view.height / 24
    
    scrollView.boxes.addObject(bufferBox)
    
    let firstNameBox = MGBox(size: CGSizeMake(view.width / 2, 32))
    
    firstNameBox.topMargin = 64
    firstNameBox.bottomPadding = 8
    
    let firstNameTextField = UITextField(frame: firstNameBox.frame)
    
    firstNameTextField.backgroundColor = UIColor.whiteColor()
    firstNameTextField.placeholder = "jon"
    
    firstNameBox.addSubview(firstNameTextField)
    
    scrollView.boxes.addObject(firstNameBox)
    
    let lastNameBox = MGBox(size: CGSizeMake(view.width / 2, 32))
    
    lastNameBox.topMargin = 64
    lastNameBox.bottomPadding = 8
    
    let lastNameTextField = UITextField(frame: firstNameBox.frame)
    
    lastNameTextField.backgroundColor = UIColor.whiteColor()
    lastNameTextField.placeholder = "doe"
    
    lastNameBox.addSubview(lastNameTextField)
    
    scrollView.boxes.addObject(lastNameBox)
    
    let phoneBox = MGBox(size: CGSizeMake(view.width, 32))
    
    phoneBox.bottomPadding = 8
    
    let phoneTextField = UITextField(frame: phoneBox.frame)
    
    phoneTextField.placeholder = "(nnn) nnn-nnnn"
    phoneTextField.backgroundColor = UIColor.whiteColor()
    
    phoneBox.addSubview(phoneTextField)
    
    scrollView.boxes.addObject(phoneBox)
    
    let emailBox = MGBox(size: CGSizeMake(view.width, 32))
    
    emailBox.bottomPadding = 8
    
    let emailTextField = UITextField(frame: emailBox.frame)
    
    emailTextField.placeholder = "john@doe.com"
    emailTextField.backgroundColor = UIColor.whiteColor()
    
    emailBox.addSubview(emailTextField)
    
    scrollView.boxes.addObject(emailBox)
    
    let passwordBox = MGBox(size: CGSizeMake(view.width, 32))
    
    passwordBox.bottomPadding = 8
    
    let passwordTextField = UITextField(frame: passwordBox.frame)
    
    passwordTextField.placeholder = "password"
    passwordTextField.backgroundColor = UIColor.whiteColor()
    passwordTextField.secureTextEntry = true
    
    passwordBox.addSubview(passwordTextField)
    
    scrollView.boxes.addObject(passwordBox)
    
    let submitBox = MGBox(size: CGSizeMake(view.width, 32))
    
    // submitBox.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    let submitButton = UIButton(frame: submitBox.frame)
    
    submitButton.setTitle("Sign Up", forState: .Normal)
    // submitButton.backgroundColor = UIColor.whiteColor()
    submitButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let parameters = [
        "first_name": firstNameTextField.text,
        "last_name": lastNameTextField.text,
        "phone": phoneTextField.text,
        "email": emailTextField.text,
        "password": passwordTextField.text
      ]
      
      Alamofire.request(Method.POST, "http://localhost:3000/v1/users", parameters: parameters)
        .responseJSON { req, res, data, err in
          if err == nil {
            let user = JSON(data!)
            
            let userId = user["id"].stringValue as String
            
            NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userid")
            NSUserDefaults.standardUserDefaults().setObject(emailTextField.text, forKey: "username")
            SSKeychain.setPassword(passwordTextField.text, forService: "Rapido", account: "co.rapido.rapido")
            
            self.delegate?.signUpViewController(self, didSignUpUser: userId)
          }
          else {
            let alert = UIAlertController(title: "Oops!", message: "It looks like you left something blank.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
          }
      }
    }
    
    submitBox.addSubview(submitButton)
    
    scrollView.boxes.addObject(submitBox)
  }
  
  override func viewDidAppear(animated: Bool) {
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
