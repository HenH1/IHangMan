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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
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
        
        if let userName = userNameField.text where userName != "", let password = passwordField.text where password != "" {
           
            FIRAuth.auth()?.signInWithEmail(userName, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.showErrorAlert("Could not connect", msg: "Please try again")
                    return
                }
                
                if let user = user {
                    print(user.uid)
                   NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "KEY_UID")
                    self.performSegueWithIdentifier("goToHome", sender: nil)
                }
                
                
            }
        } else {
            showErrorAlert("User Name and Password Requiered", msg: "You must enter User Name and Password")
            
        }
    }
    
    @IBAction func attemptSignUp(sender: UIButton!){
        if let userName = userNameField.text where userName != "", let password = passwordField.text where password != "" {
            
            FIRAuth.auth()!.createUserWithEmail(userName, password: password, completion: { (authData, error)  in
                if error == nil {
                    // Log user in
                    self.attemptLogin(nil)
                
                } else {
                    // Handle login error here
                    self.showErrorAlert("Could not sign up", msg: "Please try again")                    
                }
            })
            
        } else {
            showErrorAlert("User Name and Password Requiered", msg: "You must enter User Name and Password")
            
        }

    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    

}

