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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "b4.jpg")!)
        
          }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {

        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, targetSize.width, targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
    
    @IBAction func moveToCahmp(sender: UIButton!){
        self.performSegueWithIdentifier("goToChamp", sender: self)
    }
    
    @IBAction func moveToInstructions(sender: UIButton!){
        self.performSegueWithIdentifier("goToInstructions", sender: self)
    }
    
    
    
}
