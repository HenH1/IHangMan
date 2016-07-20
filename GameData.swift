//
//  GameData.swift
//  gameHang
//
//  Created by Hen Hershko on 11/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

class GameData {
    //store the user's game achievement
    var points:Int = 0 {
        didSet {
            //custom setter - keep the score positive
            points = max(points, 0)
        }
    }
}
