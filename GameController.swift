//
//  GameController.swift
//  gameHang
//
//  Created by Hen Hershko on 10/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GameController {
    private let ref = FIRDatabase.database().reference()
    var gameView: UIView!
    var category: Category!
    
    var hud:HUDView! {
        didSet {
            //connect the start button
            hud.startButton.addTarget(self, action: #selector(GameController.actionStartOver), forControlEvents:.TouchUpInside)
            hud.exitButton.addTarget(self, action: #selector(GameController.actionExit), forControlEvents:.TouchUpInside)

        }
    }
    var hangMa: HangmanView!
    private var tiles = [TileView]()
    private var targets = [TargetView]()
    private var correctTiles = [TileView]()
    private var isGameOver = false
    private var seconds: Int = 0
    private var timer: NSTimer?
    private var data = GameData()
    private var audioController: AudioController
    private var countError = 0
    private var bonus = 12
    private var userName = ""
    var onHangmanExit:( () -> ())!

    var onHangmanSolved:( () -> ())!

    init() {
        self.audioController = AudioController()
        self.audioController.preloadAudioEffects(AudioEffectFiles)
    }

    @objc func actionStartOver() {
        //game finished
        self.clearBoard()
        self.onHangmanSolved()
        hud.hidden = true
    }
    
    @objc func actionExit() {
        //on press Exit
        self.onHangmanExit()
        print("Bye Bye")
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    func saveToDB() // saving result in the DB
    {
        //data.points
        //userName
        //seconds
        let score = data.points
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
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////

    func dealRandomWord () {
        assert(category.word.count > 0, "no level loaded")
        let randomIndex = randomNumber(0, maxX:UInt32(category.word.count-1))
        let anagramPair = category.word[randomIndex]
        let anagram1 = anagramPair[0] as! String
        let anagram1length = anagram1.characters.count
        print("phrase1[\(anagram1length)]: \(anagram1)")
        
        //calculate the tile size
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(max(6, 5))) - TileMargin
        
        //get the left margin for first tile
        var xOffset = (ScreenWidth - CGFloat(max(6, 5)) * (tileSide + TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset += (tileSide+10) / 2.0
        
        //calculate the tile size
        let tileSide2 = ceil(ScreenWidth * 0.9 / CGFloat(min(6, 5))) - TileMargin
        
        //get the left margin for first tile
        var xOffset2 = (ScreenWidth - CGFloat(min(6, 5)) * (tileSide2 + TileMargin)) / 2.0
        
        //adjust for tile center (instead of the tile's origin)
        xOffset2 += (tileSide2+10) / 2.0
        
        //calculate the tile size
        let tileSide3 = ceil(ScreenWidth * 0.9 / CGFloat(max(6,anagram1length))) - TileMargin
        //get the left margin for first target
        var xOffset3 = (ScreenWidth - CGFloat(max(6,anagram1length)) * (tileSide3 + TileMargin)) / 2.0
        //adjust for tile center (instead of the target's origin)
        xOffset3 += (tileSide3+10) / 2.0
        
        //initialize target list
        targets = []
        //create targets
        for (index, letter) in anagram1.characters.enumerate() {
            if letter != " " {
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPointMake(ScreenWidth-(xOffset3 + CGFloat(index)*(tileSide3 + TileMargin)), ScreenHeight/4)
                
                gameView.addSubview(target)
                targets.append(target)
            }
        }
        
        // initialize tile list with keyboard strings
        tiles = []
        let ab1 = "והדגבא"
        let ab2 = "כיטחז"
        let ab3 = "פעסנמל"
        let ab4 = "תשרקצ"
        
        
        // create tiles
        initKeyboard(ab1, xOffset: xOffset, tileSide: tileSide, tileSideL: tileSide, y: 4.4)
        initKeyboard(ab2, xOffset: xOffset2, tileSide: tileSide, tileSideL: tileSide2, y: 3.9)
        initKeyboard(ab3, xOffset: xOffset, tileSide: tileSide, tileSideL: tileSide, y: 3.5)
        initKeyboard(ab4, xOffset: xOffset2, tileSide: tileSide, tileSideL: tileSide2, y: 3.2)
        
        // change location and hidden of objects in the screen
        initVariablesForNewGame()
    }
    
    func initKeyboard(letters:String, xOffset:CGFloat,tileSide:CGFloat,tileSideL:CGFloat,y:CGFloat)
    {
        for (index, letter) in letters.characters.enumerate() {
            if letter != " " {
                let tile = TileView(letter: letter, sideLength: tileSide)
                tile.center = CGPointMake(xOffset + CGFloat(index)*(tileSideL + TileMargin), ScreenHeight/y*3)
                //4
                gameView.addSubview(tile)
                tiles.append(tile)
                tile.randomize()
                tile.dragDelegate = self
                
            }
        }

    }

    func initVariablesForNewGame()
    {
        //start the timer
        self.startStopwatch()
        hud.gamePoints.value = 0
        data.points = 0
        countError = 0
        hud.startButton.hidden = true
        hud.hidden = false
        hud.bonus.setBonus(12)
        bonus = 12
        
        //setting back the hud to game mood.
        self.hud.pointsLabel.transform = CGAffineTransformMakeScale(1, 1)
        self.hud.gamePoints.transform = CGAffineTransformMakeScale(1, 1)
        self.hud.timerLabel.transform = CGAffineTransformMakeScale(1, 1)
        self.hud.stopwatch.transform = CGAffineTransformMakeScale(1, 1)
        self.hud.titleLabel.transform = CGAffineTransformMakeScale(1, 1)
        
        hud.bonus.hidden = false
        hud.category.hidden = false
        
        hud.pointsLabel.center = CGPointMake(ScreenWidth-60, 80)
        hud.gamePoints.center = CGPointMake(ScreenWidth-120, 80)
        hud.timerLabel.center = CGPointMake(ScreenWidth-60, 55)
        hud.stopwatch.center = CGPointMake(ScreenWidth-100, 55)
        
        hud.stopwatch.textAlignment = .Right;
        hud.titleLabel.hidden = true
        hangMa = nil
        isGameOver = false

    }
    
    func placeTile(tileView: TileView, targetView: TargetView) {
        targetView.isMatched = true
        tileView.isMatched = true
        
        tileView.userInteractionEnabled = false
        //give points
        data.points += 10 * bonus
        hud.gamePoints.setValue(data.points, duration: 0.5)

        UIView.animateWithDuration(0.35,
                                   delay:0.00,
                                   options:UIViewAnimationOptions.CurveEaseOut,
            animations: {
                tileView.center = targetView.center
                tileView.transform = CGAffineTransformIdentity
            },
            completion: {
                (value:Bool) in
                targetView.hidden = true
                tileView.layer.shadowOpacity = 0.0
        })
        let explode = ExplodeView(frame:CGRectMake(tileView.center.x, tileView.center.y, 10,10))
        tileView.superview?.addSubview(explode)
        tileView.superview?.sendSubviewToBack(explode)
        
    }
    
    func checkForSuccess() {
        for targetView in targets {
            //no success, bail out
            if !targetView.isMatched {
                return
            }
        }
        for t in self.tiles{
            t.userInteractionEnabled = false
        }

        if self.isGameOver == false
        {
            print("Game Over!")
            self.isGameOver = true
            if hangMa == nil{
                let hangman = HangmanView(countError: 0)
                hangman.center = CGPointMake(ScreenWidth/4, ScreenHeight/2)
                gameView.addSubview(hangman)
                hangMa = hangman
            }
            hangMa.setVImage(7)
            hangMa.center = CGPointMake(ScreenWidth/4, ScreenHeight/2)

        audioController.playEffect(SoundWin)
        // win animation
        let firstTarget = targets[0]
        let startX:CGFloat = 0
        let endX:CGFloat = ScreenWidth + 300
        let startY = firstTarget.center.y
        let stars = StardustView(frame: CGRectMake(startX, startY, 10, 10))
        gameView.addSubview(stars)
        gameView.sendSubviewToBack(stars)
        UIView.animateWithDuration(2.0,
                                   delay:0.0,
                                   options:UIViewAnimationOptions.CurveEaseOut,
                                   animations:{
                                    stars.center = CGPointMake(endX, startY)
            }, completion: {(value:Bool) in
                //game finished
                stars.removeFromSuperview()
                self.gameOver(true)

        })
        }
    
    }
    
    //clear the tiles and targets
    func clearBoard() {
        tiles.removeAll(keepCapacity: false)
        targets.removeAll(keepCapacity: false)
        
        for view in gameView.subviews  {
            view.removeFromSuperview()
        }
    }
    
    func startStopwatch() {
        seconds = 0
        hud.stopwatch.setSeconds(seconds)
        //schedule a new timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(GameController.tick(_:)), userInfo: nil, repeats: true)
    }
    
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func tick(timer: NSTimer) {
        hud.stopwatch.setSeconds(seconds)
        seconds += 1
        
        if seconds == 11
        {
            setBonus(10)
        }
        else if seconds == 21
        {
            setBonus(6)
        }
        else if seconds == 31
        {
            setBonus(3)
        }
        else if seconds == 61
        {
            setBonus(2)
        }
        else if seconds == 121
        {
            setBonus(1)
        }
    }
    
    func setBonus(newBonus:Int)
    {
        hud.bonus.setBonus(newBonus)
        bonus = newBonus

        UIView.animateWithDuration(2.0, animations: {() -> Void in
            self.hud.bonus.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(2.0, animations: {() -> Void in
                    self.hud.bonus.transform = CGAffineTransformMakeScale(1, 1)
                })
        })
    }
    
    func gameOver(didWin: Bool)
    {
        //stop the stopwatch
        self.stopStopwatch()
        
        //remove targert and tiles
        for t in self.tiles{
            t.hidden = true
        }
        for t in self.correctTiles{
            t.hidden = true
        }
        for t in self.targets{
            t.hidden = true
        }
        if didWin{
            hud.titleLabel.text = "הצלת את יוסף!"
            
        }
        else{
            hud.titleLabel.text = "אוו, יוסף מת.."
            self.hangMa.setVImage(10)
            hangMa.center = CGPointMake(ScreenWidth/4, ScreenHeight/2)
            self.audioController.playEffect(SoundLose)
        }
        hud.bonus.hidden = true
        hud.category.hidden = true
        hud.titleLabel.hidden = false
        hud.startButton.hidden = false

        hud.pointsLabel.center = CGPointMake(ScreenWidth/2-10, ScreenHeight*1.4/4)
        hud.gamePoints.center = CGPointMake(ScreenWidth/2-90, ScreenHeight*1.4/4)
        hud.timerLabel.center = CGPointMake(ScreenWidth/2-10, ScreenHeight*1/4)
        hud.stopwatch.center = CGPointMake(ScreenWidth/2-60, ScreenHeight*1/4)
        
        UIView.animateWithDuration(2.0, animations: {() -> Void in
            self.hud.pointsLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.hud.gamePoints.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.hud.timerLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.hud.stopwatch.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.hud.titleLabel.transform = CGAffineTransformMakeScale(2, 2)
            self.hangMa.transform = CGAffineTransformMakeScale(1.7, 1.7)

            
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(2.0, animations: {() -> Void in
                    if self.hangMa != nil {
                    self.hangMa.center = CGPointMake(ScreenWidth/2, ScreenHeight/1.7-10)
                    }
                })
        })
        saveToDB()

    }
}

extension GameController:TileDragDelegateProtocol {
    //a tile was dragged, check if matches a target
    
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var foundTarget:TargetView? = nil
        var counter = 0
        var arrTarget = [TargetView]()
        
        tileView.userInteractionEnabled = false
        for target in targets {
            if !target.isMatched && tileView.letter == target.letter{
                foundTarget = target
                counter += 1
                target.isMatched = true
                arrTarget.append(target)
            }
        }
        if foundTarget == nil{ // no match
            if countError == 0{
                let hangman = HangmanView(countError: countError)
                hangman.center = CGPointMake(ScreenWidth/4, ScreenHeight/2)
                gameView.addSubview(hangman)
                hangMa = hangman
            }
            else{
                hangMa.setVImage(countError)
                hangMa.center = CGPointMake(ScreenWidth/4, ScreenHeight/2)

            }
            tileView.hidden = true
            tiles.removeObject(tileView)
            countError += 1
            audioController.playEffect(SoundWrong)
            if countError == 7{
                gameOver(false)
            }
        }
        else{  //there is a matching tile and target(s)
            for i in 0...counter-1
            {
                tileView.hidden = true
                let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(max(6, 5))) - TileMargin
                
                let tile = TileView(letter: tileView.letter, sideLength: tileSide)
                tile.center = tileView.center
                gameView.addSubview(tile)
                tile.randomize()
                tile.dragDelegate = self
                
                //animation
                tile.layer.shadowOpacity = 0.8
                tile.transform = CGAffineTransformScale(tile.transform, 1.3, 1.3)
                correctTiles.append(tile)
                // don't want the tile sliding under other tiles
                gameView.bringSubviewToFront(tile)
                
                // show the animation to the user
                UIView.animateWithDuration(1.5,
                                           delay:0.0,
                                           options:UIViewAnimationOptions.CurveEaseOut,
                                           animations:{
                                            tile.center = arrTarget[i].center
                                            for t in self.tiles{
                                                t.userInteractionEnabled = false
                                            }
                    }, completion: {
                        (value:Bool) in
                        
                        // adjust view on spot
                        self.placeTile(tile, targetView: arrTarget[i])
                        self.audioController.playEffect(SoundDing)
                        for t in self.tiles{
                            t.userInteractionEnabled = true
                        }
                        // check for finished game
                        if self.isGameOver == false{
                            self.checkForSuccess()
                        }
                })
            }
        }

    }
 }

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}