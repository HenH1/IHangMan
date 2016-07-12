//
//  GameBoardViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/12/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit
import Firebase


class GameBoardViewController: UIViewController {

    
    private let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testAddData(sender: UIButton!){
        
        let score = 50
        if let uid = NSUserDefaults.standardUserDefaults().stringForKey("KEY_UID"){
            //this is how you put data of new game into firebase database
            let gameId = self.ref.child("users").child(uid).child("games").childByAutoId()
            gameId.updateChildValues(["score": score])
            self.ref.child("games").child(gameId.key).updateChildValues(["score": score, "userId":uid])
            print("Game id: " + gameId.key)
        }
        else{
        print("not success to retreive uid from nsuserdefaults, can't save game data")
        }
 
    }
    
    
    @IBAction func testGetData(sender: UIButton!){
        let query = (ref.child("games")).queryOrderedByChild("score")
        
        query.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            print("Ordered by Value")
            print(snapshot.value)
        })

    
    }
    

}
