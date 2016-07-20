//
//  ViewController.swift
//  gameHang
//
//  Created by Hen Hershko on 10/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import UIKit
import Firebase

class GameBoardViewController: UIViewController {

    
    private let ref = FIRDatabase.database().reference()
    
    private let controller:GameController
    private var hudView = HUDView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
    
    required init?(coder aDecoder: NSCoder) {
        controller = GameController()
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "b4.jpg")!
        self.view.backgroundColor = UIColor(patternImage: image)
        
        //add one layer for all game elements
        let gameView = UIView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        
        //add one view for all hud and controls
        hudView.hidden = true
        self.view.addSubview(hudView)
        controller.hud = hudView
        
        controller.onHangmanSolved = self.showLevelMenu
        controller.onHangmanExit = self.dismissView
        
    }
    func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //show the game menu on app start
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.showLevelMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showLevelMenu() {
        
        hudView.hidden = true
        //1 show the level selector menu
        let alertController = UIAlertController(title: "בחר קטגוריה:",
                                                message: nil,
                                                preferredStyle:UIAlertControllerStyle.Alert)
        
        //2 set up the menu actions
        let c1 = UIAlertAction(title: "אוכל", style:.Default,
                               handler: {(alert:UIAlertAction!) in
                                self.showLevel(1)
                                self.hudView.category.setCategoty(" אוכל ")
        })
        let c2 = UIAlertAction(title: "חיות", style:.Default,
                               handler: {(alert:UIAlertAction!) in
                                self.showLevel(2)
                                self.hudView.category.setCategoty(" חיות ")
                                
        })
        let c3 = UIAlertAction(title: "איברי גוף", style: .Default,
                               handler: {(alert:UIAlertAction!) in
                                self.showLevel(3)
                                self.hudView.category.setCategoty(" איברי גוף ")
                                
        })
        let c4 = UIAlertAction(title: "ערים", style: .Default,
                               handler: {(alert:UIAlertAction!) in
                                self.showLevel(4)
                                self.hudView.category.setCategoty(" ערים ")
                                
        })
        // add the menu actions to the menu
        alertController.addAction(c1)
        alertController.addAction(c2)
        alertController.addAction(c3)
        alertController.addAction(c4)
        
        // show the UIAlertController
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // show the appropriate level selected by the player
    func showLevel(levelNumber:Int) {
        controller.category = Category(categoryName: levelNumber)
        controller.dealRandomWord()
    }
}
