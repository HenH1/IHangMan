//
//  ChampTableViewController.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/14/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit
import Firebase


class ChampTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var tableview :UITableView!
    
    var names2 =  [String]()
    var scores = [String]() //["1000","20000","203","40","506"]
    var names =  [String]() //["במבה שוש", "קוקו ג׳מבו", "מומו בובו", "גוגו משמש", "אלי פלפלי"]
    var champs = [Champ]()
    
    var ids = [".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9", ".10"]
    var gamesId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "b4.jpg")!)
        tableview.delegate = self
        tableview.dataSource = self
        
        self.champs = []
        let query = ref.child("games").queryOrderedByChild("score")
        query.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                   // print("SNAP: \(snap)")
                    
                    if let champDict = snap.value as? Dictionary<String, AnyObject> {
                        //print(champDict)
                        let key = snap.key
                        let champ = Champ(champKey: key, dictionary: champDict)
                        
                        self.champs.append(champ)
                        
                        
                    }
                }
            }
            
            
          // self.tableview.reloadData()
        
        })
        
        
        ref.child("users").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
                if let usersDict = snapshot.valueInExportFormat() as? NSDictionary {
                    for item in self.champs{
                        if let user = usersDict[item.userId] as? Dictionary<String, AnyObject> {
                            
                            if let userName = user["userName"] as? String{
                                item.name = userName
                            }
                        }
                        
                    }
            }
            if (self.champs.count > 10) {
                self.champs = Array(self.champs.reverse().dropLast(self.champs.count - 10))
            }
            
            self.tableview.reloadData()
            
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return champs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let champ = champs[indexPath.row]
        //print(champ)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("uglyCell") as? champCell {
            
            cell.configureCell(champ, id: "." + String(indexPath.row + 1))
            return cell
        }else {
            return champCell()
        }
    }
    
    @IBAction func moveToHome(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
