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


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "b4.jpg")!)
        // Do any additional setup after loading the view, typically from a nib.
        passwordField.secureTextEntry = true
        emailField.delegate = self
        passwordField.delegate = self
        passwordField.returnKeyType = .Done
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordField
        {
            self.view.endEditing(true)
            loginBtn.sendActionsForControlEvents(.TouchUpInside)
            return false
        }
        passwordField.becomeFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func attemptLogin(sender: UIButton!){
        
        if let email = emailField.text where email != "", let password = passwordField.text where password != "" {
              
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                if let errorCode = error?.code {
                    
                    print(error?.localizedDescription)
                   print(error?.code)
                        var msg = ""
                        
                        switch errorCode {
                        case 17010:
                            msg = "מכשירך נחסם עקב פעילות חריכה, נסה שנית מאוחר יותר"
                        case 17009:
                            msg = "ססמא שגויה"
                        case 17011:
                            msg = "אימייל לא קיים במערכת"
                        case 17026 :
                            msg = "הססמא חייבת להיות ארוכה מ-6 תווים או יותר"
                        case 17008:
                            msg = "אימייל בפורמט לא תקין"
                        default:
                            msg = "שגיאה כללית, נסה שנית"
                        }
                    
                        self.showErrorAlert("שגיאת התחברות", msg: msg)
                    
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
            showErrorAlert("שגיאת התחברות", msg: "הכנס שם משתמש וססמא")
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

