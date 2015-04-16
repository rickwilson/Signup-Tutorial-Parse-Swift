//
//  SignUpInViewController.swift
//  Signup-Tutorial-Parse-Swift
//
//  Created by Rick Wilson on 4/15/15.
//  Copyright (c) 2015 Rick Wilson. All rights reserved.
//

import UIKit
import Parse

class SignUpInViewController: UIViewController {
    @IBOutlet weak var messageAlertDisplayLabel: UILabel!
    @IBOutlet weak var emailAddressInputTestField: UITextField!
    @IBOutlet weak var passwordInputTextField: UITextField!
    @IBOutlet weak var SigningInActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func signUpButton(sender: AnyObject) {
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func signInButton(sender: AnyObject) {
        SigningInActivityIndicator.hidden = false
        SigningInActivityIndicator.startAnimating()
        
        var userEmailAddress = emailAddressInputTestField.text
        userEmailAddress = userEmailAddress.lowercaseString
        var userPassword = passwordInputTextField.text

        
        PFUser.logInWithUsernameInBackground(userEmailAddress, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
            } else {
                self.SigningInActivityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.messageAlertDisplayLabel.text = "\(message)"
                }
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SigningInActivityIndicator.hidden = true
        SigningInActivityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processSignUp() {
        
        var userEmailAddress = emailAddressInputTestField.text
        var userPassword = passwordInputTextField.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress.lowercaseString
        
        // Add email address validation
        
        // Start activity indicator
        SigningInActivityIndicator.hidden = false
        SigningInActivityIndicator.startAnimating()
        
        // Create the user
        var user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("signInToNavigation", sender: self)
                }
                
            } else {
                
                self.SigningInActivityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.messageAlertDisplayLabel.text = "\(message)"
                }				
            }
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
