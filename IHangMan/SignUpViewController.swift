//
//  SignUpViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/12/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class SignUpViewController: UIViewController {
    
    private let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func attemptToSignUp(sender: UIButton!){

        if let email = emailField.text where email != "", let password = passwordField.text where password != "", let userName = userNameField.text where userName != "", let confirmPassword = confirmPasswordField.text where confirmPassword != "" {
            
            FIRAuth.auth()!.createUserWithEmail(email, password: password, completion: { (authData, error)  in
                if error == nil {
                
                    //update user details on firebase database
                    
                    self.ref.child("users").child(authData!.uid).updateChildValues(["userName": userName])
                
                    
                    // move to Log in
                  self.dismissViewControllerAnimated(true, completion: nil)
                      //  self.showAlert("Sign Up successfully", msg: "")
                  
                } else {
                    // Handle login error here
                    self.showAlert("Could not sign up", msg: "Please try again")
                }
            })
            
        } else {
           showAlert("User Name and Password Requiered", msg: "You must enter User Name and Password")
        }
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
}
