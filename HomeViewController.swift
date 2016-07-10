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
         self.performSegueWithIdentifier("goToLogin", sender: nil)
        
    }
    
}
