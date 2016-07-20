//
//  InstructionsViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/17/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "b4.jpg")!)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func moveToHome(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
