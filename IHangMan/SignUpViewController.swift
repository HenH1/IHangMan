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



class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    private let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "b4.jpg")!)
        // Do any additional setup after loading the view, typically from a nib.
        passwordField.secureTextEntry = true
        confirmPasswordField.secureTextEntry = true

        userNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self

        confirmPasswordField.returnKeyType = .Done
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == confirmPasswordField
        {
            self.view.endEditing(true)
            signupBtn.sendActionsForControlEvents(.TouchUpInside)
            return false
        }
        if textField == userNameField
        {
            emailField.becomeFirstResponder()
            return true
        }
        if textField == emailField
        {
            passwordField.becomeFirstResponder()
            return true
        }
        confirmPasswordField.becomeFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func attemptToSignUp(sender: UIButton!){

        if let email = emailField.text where email != "", let password = passwordField.text where password != "", let userName = userNameField.text where userName != "", let confirmPassword = confirmPasswordField.text where confirmPassword != "" {
            
            if (password != confirmPassword) {
                showAlert("ססמאות לא תואמות", msg: "נסה שנית")
            }
            
            FIRAuth.auth()!.createUserWithEmail(email, password: password, completion: { (authData, error)  in
                if error == nil {
                
                    //update user details on firebase database
                    
                    self.ref.child("users").child(authData!.uid).updateChildValues(["userName": userName])
                
                    
                    // move to Log in
                  self.dismissViewControllerAnimated(true, completion: nil)
                      //  self.showAlert("Sign Up successfully", msg: "")
                  
                } else {
                    // Handle login error here
                    if let code = error?.code {
                        var msg = ""
                        
                        switch code {
                        case 17007:
                            msg = "כתובת המייל תפוסה ע״י משתמש אחר"
                        case 17026 :
                            msg = "הססמא חייבת להיות ארוכה מ-6 תווים או יותר"
                        case 17008:
                            msg = "אימייל בפורמט לא תקין"
                        default:
                            msg = "שגיאה כללית, נסה שנית"
                        }
                        
                        print(error?.localizedDescription)
                          self.showAlert("נתונים שגויים", msg: msg)
                    }else {
                        self.showAlert("נתונים שגויים", msg: "נסה שנית")
                    }
                }
            })
            
        } else {
           showAlert("פרטים חסרים", msg: "מלא את הפרטים החסרים ונסה שנית")
        }
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func moveToLogin(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
