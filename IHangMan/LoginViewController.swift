//
//  ViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/8/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func attemptLogin(sender: UIButton!){
        
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
              
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.showErrorAlert("Could not connect", msg: "Please try again")
                    return
                }
                if let user = user {
                    print(user.uid)
                    NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "KEY_UID")
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "KEY_IS_LOGGED_IN")
                   // FIRDatabase.database().reference().child("users").child(user.uid).setValue(user.uid)
                   // DataSerivce.ds.USERS_REF.child(user.uid)
                
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        } else {
            showErrorAlert("email and Password Requiered", msg: "You must enter email and Password")
        }
    }

    @IBAction func moveToSignUpSegue(sender: UIButton!){
      
         self.performSegueWithIdentifier("goToSignUp", sender: self)

    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    

}

