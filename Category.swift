//
//  Category.swift
//  gameHang
//
//  Created by Hen Hershko on 10/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
struct Category {
    //let pointsPerTile: Int
    //let timeToSolve: Int
    let word: [NSArray]
    
    init(categoryName: Int) {
        //1 find .plist file for this level
        let fileName = "\(categoryName).plist"
        let levelPath = "\(NSBundle.mainBundle().resourcePath!)/\(fileName)"
        
        //2 load .plist file
        let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
        
        //3 validation
        assert(levelDictionary != nil, "Level configuration file not found")
        
        //4 initialize the object from the dictionary
        //self.pointsPerTile = levelDictionary!["pointsPerTile"] as! Int
        //self.timeToSolve = levelDictionary!["timeToSolve"] as! Int
        self.word = levelDictionary!["word"] as! [NSArray]
    }
}

