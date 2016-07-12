//
//  HomeViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/11/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view, typically from a nib.
          }
    
    override func viewDidAppear(animated: Bool) {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("KEY_IS_LOGGED_IN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goToLogin", sender: self)
        } else {
            
            //keep continue 
            
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: UIButton!){
        print("logging out")
        do{
            try FIRAuth.auth()!.signOut()
            
        }
        catch {
            print("Error while trying signout")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(0, forKey: "KEY_IS_LOGGED_IN")
        self.performSegueWithIdentifier("goToLogin", sender: nil)
        
    }
    
    @IBAction func moveToGameBoard(sender: UIButton!){
    self.performSegueWithIdentifier("goToGameBoard", sender: self)
    }

    
    
}
