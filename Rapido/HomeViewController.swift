//
//  HomeViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

protocol HomeViewControllerProtocol {
  func homeViewControllerProtocolDidFinishHome(controller: HomeViewController)
}

class HomeViewController: UIViewController, SignInViewControllerProtocol, SignUpViewControllerProtocol, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var delegate: HomeViewControllerProtocol?
  
  var facebookButton: FBSDKLoginButton?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    scrollView.width = view.width
    
    let blue = UIColor(hexString: "#106AAA")
    
    // Logo
    let logo = UIImage(named: "Rapido")
    
    let logoBox = MGBox(size: CGSizeMake(view.width, logo!.size.width))
    
    logoBox.topMargin = view.height / 8
    
    let logoView = UIImageView(frame: logoBox.frame)
    
    logoView.image = logo
    
    logoBox.addSubview(logoView)
    
    scrollView.boxes.addObject(logoBox)
    
    // Facebook Login
    let facebookBox = MGBox(size: CGSizeMake(view.width, 64))
    
    facebookBox.bottomPadding = 8
    
    facebookButton = FBSDKLoginButton()
    facebookButton?.delegate = self
    
    facebookButton?.readPermissions = ["public_profile", "email"]
    
    facebookButton!.width = view.width - 16
    facebookButton!.height = 64
    facebookButton!.center = facebookBox.center
    
    facebookBox.addSubview(facebookButton!)
    
    scrollView.boxes.addObject(facebookBox)

    // Sign In
    let signInBox = MGBox(size: CGSizeMake(view.width / 2, 64))
    
    // signInBox.topMargin = 64
    
    let signInButton = UIButton(frame: signInBox.frame)
    
    signInButton.size.width = view.width / 2 - 16
    signInButton.center = signInBox.center
    
    signInButton.layer.cornerRadius = 3
    signInButton.setTitle("Sign In", forState: .Normal)
    signInButton.backgroundColor = blue
    signInButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
      
      signInViewController.delegate = self
      
      self.presentViewController(signInViewController, animated: true, completion: nil)
    }
    
    signInBox.addSubview(signInButton)
    
    scrollView.boxes.addObject(signInBox)
    
    // Sign Up
    let signUpBox = MGBox(size: CGSizeMake(view.width / 2, 64))
    
    let signUpButton = UIButton(frame: signUpBox.frame)
    
    signUpButton.size.width = view.width / 2 - 16
    signUpButton.center = signUpBox.center
    
    signUpButton.layer.cornerRadius = 3
    signUpButton.setTitle("Sign Up", forState: .Normal)
    signUpButton.backgroundColor = blue
    signUpButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
      
      signUpViewController.delegate = self
      
      self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    signUpBox.addSubview(signUpButton)
    
    scrollView.boxes.addObject(signUpBox)
    
    scrollView.layoutWithDuration(0.3, completion: { () -> Void in
      
    });
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func signInViewController(controller: SignInViewController, didLogInUser userId: String) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
    delegate?.homeViewControllerProtocolDidFinishHome(self)
  }
  
  func signInViewControllerDidCancelLogIn(controller: SignInViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func signUpViewController(controller: SignUpViewController, didSignUpUser userId: String) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
    delegate?.homeViewControllerProtocolDidFinishHome(self)
  }
  
  func signUpViewControllerDidCancelSignUp(controller: SignUpViewController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    let token = result.token.tokenString
    
    Alamofire.request(.POST, "\(Globals.BASE_URL)/FBLogIn?token=\(Globals.API_TOKEN)", parameters: ["token": token]).responseJSON {
      (req, res, data, err) in
      let user = JSON(data!)
      
      let userId = user["id"].stringValue as String
      
      NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userid")
      // NSUserDefaults.standardUserDefaults().setObject(user["email"].string, forKey: "username")
      // SSKeychain.setPassword(passwordTextField.text, forService: "Rapido", account: "co.rapido.rapido")
      
      if let phone = user["phone"].string {
        self.delegate?.homeViewControllerProtocolDidFinishHome(self)
      }
      else {
        let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
      
        signUpViewController.user = user
        signUpViewController.delegate = self
      
        self.presentViewController(signUpViewController, animated: true, completion: nil)
      }
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    
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
