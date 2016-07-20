//
//  TileView.swift
//  gameHang
//
//  Created by Hen Hershko on 10/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
import UIKit

protocol TileDragDelegateProtocol {
    func tileView(tileView: TileView, didDragToPoint: CGPoint)
}

class TileView:UIImageView {
    var letter: Character
    
    var isMatched: Bool = false
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    var dragDelegate: TileDragDelegateProtocol?
    private var tempTransform: CGAffineTransform = CGAffineTransformIdentity

    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    //5 create a new tile for a given letter
    init(letter:Character, sideLength:CGFloat) {
        self.letter = letter
        
        //the tile background
        let image = UIImage(named: "tile")!
        
        //superclass initializer
        //references to superview's "self" must take place after super.init
        super.init(image:image)
        
        //6 resize the tile
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        //add a letter on top
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.textAlignment = NSTextAlignment.Center
        letterLabel.textColor = UIColor.whiteColor()
        letterLabel.backgroundColor = UIColor.clearColor()
        letterLabel.text = String(letter).uppercaseString
        letterLabel.font = UIFont(name: "DanaYadAlefAlefAlef-Normal", size: 105.0*scale)

        self.addSubview(letterLabel)
        self.userInteractionEnabled = true
        
        //create the tile shadow
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSizeMake(10.0, 10.0)
        self.layer.shadowRadius = 15.0
        self.layer.masksToBounds = false
        
        let path = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = path.CGPath

    }
    
    func randomize() {
        //set random rotation of the tile
        //anywhere between -0.2 and 0.3 radians
        let rotation = CGFloat(randomNumber(0, maxX:50)) / 100.0 - 0.2
        self.transform = CGAffineTransformMakeRotation(rotation)
        
        //move randomly upwards
        let yOffset = CGFloat(randomNumber(0, maxX: 10) - 10)
        self.center = CGPointMake(self.center.x, self.center.y + yOffset)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let point = touch.locationInView(self.superview)
            xOffset = point.x - self.center.x
            yOffset = point.y - self.center.y
            self.layer.shadowOpacity = 0.8
            //save the current transform
            tempTransform = self.transform
            //enlarge the tile
            self.transform = CGAffineTransformScale(self.transform, 1.2, 1.2)
            self.superview?.bringSubviewToFront(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let point = touch.locationInView(self.superview)
            self.center = CGPointMake(point.x - xOffset, point.y - yOffset)
            self.layer.shadowOpacity = 0.8
            self.superview?.bringSubviewToFront(self)

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchesMoved(touches, withEvent: event)
        dragDelegate?.tileView(self, didDragToPoint: self.center)
        self.transform = tempTransform
        self.layer.shadowOpacity = 0.0
    }
    //reset the view transform in case drag is cancelled
    override func touchesCancelled(touches: Set<UITouch>!, withEvent event: UIEvent!) {
        self.transform = tempTransform
        self.layer.shadowOpacity = 0.0
    }
}