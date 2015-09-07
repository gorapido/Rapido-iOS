//
//  SignInViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/1/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit
import Alamofire
import SwiftyJSON
import SSKeychain

protocol SignInViewControllerProtocol {
  func signInViewController(controller: SignInViewController, didLogInUser userId: String)
  func signInViewControllerDidCancelLogIn(controller: SignInViewController)
}

class SignInViewController: UIViewController {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var delegate: SignInViewControllerProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
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
      self.delegate?.signInViewControllerDidCancelLogIn(self)
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
    
    // Email
    let emailBox = MGBox(size: CGSizeMake(view.width, 32))
    
    emailBox.bottomMargin = 8
    emailBox.backgroundColor = UIColor.whiteColor()
    
    let emailTextField = UITextField(frame: emailBox.frame)
    
    emailTextField.width = view.width - 16
    emailTextField.center = emailBox.center
    emailTextField.placeholder = "email"
    emailTextField.backgroundColor = UIColor.whiteColor()
    
    emailBox.addSubview(emailTextField)
    
    scrollView.boxes.addObject(emailBox)
    
    // Password
    let passwordBox = MGBox(size: CGSizeMake(view.width, 32))
    
    passwordBox.bottomMargin = 8
    passwordBox.backgroundColor = UIColor.whiteColor()
    
    let passwordTextField = UITextField(frame: passwordBox.frame)
    
    passwordTextField.width = view.width - 16
    passwordTextField.center = passwordBox.center
    passwordTextField.placeholder = "password"
    passwordTextField.backgroundColor = UIColor.whiteColor()
    passwordTextField.secureTextEntry = true
    
    passwordBox.addSubview(passwordTextField)
    
    scrollView.boxes.addObject(passwordBox)
    
    // Submit
    let submitBox = MGBox(size: CGSizeMake(view.width, 32))
    
    // submitBox.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    let submitButton = UIButton(frame: submitBox.frame)
    
    submitButton.setTitle("Sign In", forState: .Normal)
    // submitButton.backgroundColor = UIColor.whiteColor()
    submitButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      Alamofire.request(.GET, "\(Globals.BASE_URL)/signIn?token=\(Globals.API_TOKEN)")
        .authenticate(user: emailTextField.text, password: passwordTextField.text)
        .responseJSON { req, res, data, err in
          if err == nil {
            let user = JSON(data!)
            
            let userId = user["id"].stringValue as String
            
            NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userid")
            NSUserDefaults.standardUserDefaults().setObject(emailTextField.text, forKey: "username")
            SSKeychain.setPassword(passwordTextField.text, forService: "Rapido", account: "co.rapido.rapido")
            
            self.delegate?.signInViewController(self, didLogInUser: userId)
          }
          else {
            let alert = UIAlertController(title: "Oops!", message: "It looks like your log in credentials are incorrect.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
          }
      }
    }
    
    submitBox.addSubview(submitButton)
    
    scrollView.boxes.addObject(submitBox)
    
    let forgotBox = MGBox(size: CGSizeMake(view.width, 32))
    
    let forgotButton = UIButton(frame: forgotBox.frame)
    
    forgotButton.setTitle("Forgot password?", forState: .Normal)
    forgotButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let alert = UIAlertController(title: "Reset Password", message: "Enter your email address.", preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addTextFieldWithConfigurationHandler { textField in
        textField.placeholder = "email"
      }
      
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) { action in
        // Send password reset request.
        let email = alert.textFields![0] as! UITextField
        
        Alamofire.request(.PATCH, "\(Globals.BASE_URL)/reset_password?token=\(Globals.API_TOKEN)", parameters: ["email": email.text]).responseJSON { req, res, data, err in
          
        }
      })
      
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    forgotBox.addSubview(forgotButton)
    
    scrollView.boxes.addObject(forgotBox)
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
