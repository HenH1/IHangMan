//
//  Config.swift
//  gameHang
//
//  Created by Hen Hershko on 10/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
import UIKit

//UI Constants
let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height



//Random number generator
func randomNumber(minX:UInt32, maxX:UInt32) -> Int {
    let result = (arc4random() % (maxX - minX + 1)) + minX
    return Int(result)
}

let TileMargin: CGFloat = 10.0

let FontHUD = UIFont(name:"comic andy", size: 50.0)!
let Font2 = UIFont(name:"ComixNo2CLM-Bold", size: 22.0)!
let Font2Big = UIFont(name:"ComixNo2CLM-Bold", size: 30.0)!
let Font3 = UIFont(name:"Asakim", size: 35.0)!

// Sound effects
let SoundDing = "ding.mp3"
let SoundWrong = "wrong.m4a"
let SoundWin = "win.mp3"
let SoundLose = "ouch.mp3"

let AudioEffectFiles = [SoundDing, SoundWrong, SoundWin, SoundLose]
