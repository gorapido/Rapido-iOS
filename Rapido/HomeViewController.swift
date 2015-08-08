//
//  HomeViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 8/2/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MGBoxKit

protocol HomeViewControllerProtocol {
  func homeViewControllerProtocolDidFinishHome(controller: HomeViewController)
}

class HomeViewController: UIViewController, SignInViewControllerProtocol, SignUpViewControllerProtocol {
  
  @IBOutlet weak var scrollView: MGScrollView!
  
  var delegate: HomeViewControllerProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    scrollView.contentLayoutMode = MGLayoutGridStyle
    
    let logo = UIImage(named: "Rapido")
    
    let logoBox = MGBox(size: CGSizeMake(view.width, logo!.size.width))
    
    logoBox.topMargin = view.height / 8
    
    let logoView = UIImageView(frame: logoBox.frame)
    
    logoView.image = logo
    
    logoBox.addSubview(logoView)
    
    scrollView.boxes.addObject(logoBox)
    
    let facebookBox = MGBox(size: CGSizeMake(view.width, 64))
    
    facebookBox.bottomPadding = 8
    
    let facebookButton = UIButton(frame: facebookBox.frame)
    
    facebookButton.setTitle("Sign In with Facebook", forState: .Normal)
    facebookButton.backgroundColor = UIColor.blueColor()
    facebookButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      
    }
    
    facebookBox.addSubview(facebookButton)
    
    scrollView.boxes.addObject(facebookBox)
    
    let googleBox = MGBox(size: CGSizeMake(view.width, 64))
    
    googleBox.bottomPadding = 8
    
    let googleButton = UIButton(frame: googleBox.frame)
    
    googleButton.setTitle("Sign In with Google+", forState: .Normal)
    googleButton.backgroundColor = UIColor.redColor()
    googleButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      
    }
    
    googleBox.addSubview(googleButton)
    
    scrollView.boxes.addObject(googleBox)
    
    let emailBox = MGBox(size: CGSizeMake(view.width, 64))
    
    let emailButton = UIButton(frame: emailBox.frame)
    
    emailButton.setTitle("Sign In with Email", forState: .Normal)
    emailButton.backgroundColor = UIColor.grayColor()
    emailButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let signInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
      
      signInViewController.delegate = self
      
      self.presentViewController(signInViewController, animated: true, completion: nil)
    }
    
    emailBox.addSubview(emailButton)
    
    scrollView.boxes.addObject(emailBox)
    
    let signUpBox = MGBox(size: CGSizeMake(view.width, 64))
    
    let signUpButton = UIButton(frame: signUpBox.frame)
    
    signUpButton.setTitle("Sign Up with Email", forState: .Normal)
    signUpButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    signUpButton.onControlEvent(UIControlEvents.TouchUpInside) { Void in
      let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
      
      signUpViewController.delegate = self
      
      self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    
    signUpBox.addSubview(signUpButton)
    
    scrollView.boxes.addObject(signUpBox)
  }
  
  override func viewDidAppear(animated: Bool) {
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
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
