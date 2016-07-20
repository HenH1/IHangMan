//
//  HUDView.swift
//  gameHang
//
//  Created by Hen Hershko on 11/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//



import UIKit

class HUDView: UIView {
    
    var stopwatch: StopwatchView
    var gamePoints: CounterLabelView
    var category: CategoryView
    var bonus: BonusView
    var timerLabel:UILabel!
    var pointsLabel:UILabel!
    var titleLabel:UILabel!
    var startButton: UIButton!
    var exitButton: UIButton!

    //this should never be called
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame:CGRect) {
        
        self.stopwatch = StopwatchView(frame:CGRectMake(ScreenWidth-150, 50, 100, 20))
        self.stopwatch.setSeconds(0)
        self.stopwatch.textAlignment = .Right;
        
        self.bonus = BonusView(frame:CGRectMake(10, 40, 100, 50))
        self.bonus.setBonus(12)
        self.bonus.textAlignment = .Center;
        bonus.textColor = UIColor(red: 0.38, green: 0.098, blue: 0.035, alpha: 1)

        //the dynamic points label
        self.gamePoints = CounterLabelView(font: Font2, frame: CGRectMake(ScreenWidth-170, 75, 100, 20))
        gamePoints.textColor = UIColor(red: 0.38, green: 0.098, blue: 0.035, alpha: 1)
        gamePoints.value = 0
        self.gamePoints.textAlignment = .Right;
        
        self.category = CategoryView(frame:CGRectMake(0, 0, ScreenWidth, 40))
        self.category.setCategoty("")
        self.category.textAlignment = .Right;
    
        super.init(frame:frame)
        
        self.addSubview(gamePoints)
        self.addSubview(stopwatch)
        self.addSubview(category)
        self.addSubview(bonus)

        //points label
        pointsLabel = UILabel(frame: CGRectMake(ScreenWidth-110, 75, 100, 20))
        pointsLabel.textAlignment = .Right;
        pointsLabel.backgroundColor = UIColor.clearColor()
        pointsLabel.font = Font2
        pointsLabel.text = "ניקוד:"
        self.addSubview(pointsLabel)
        
        //time label
        timerLabel = UILabel(frame: CGRectMake(ScreenWidth-110, 50, 100, 20))
        timerLabel.backgroundColor = UIColor.clearColor()
        timerLabel.textAlignment = .Right;
        timerLabel.font = Font2
        timerLabel.text = "זמן:"
        self.addSubview(timerLabel)

        //title label
        titleLabel = UILabel(frame: CGRectMake(0, ScreenHeight*0.5/4, ScreenWidth, 20))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = .Center;
        titleLabel.font = Font2
        titleLabel.text = ""
        titleLabel.layer.shadowColor = UIColor(red: 0.38, green: 0.098, blue: 0.035, alpha: 1).CGColor
        titleLabel.layer.shadowOpacity = 0.5

        self.addSubview(titleLabel)

        self.userInteractionEnabled = true
        
        //load the button image
        let buttonImage = UIImage(named: "btn")!
        
        //the help button
        self.startButton = UIButton(type: .Custom)
        startButton.setTitle("משחק חדש", forState:.Normal)
        startButton.titleLabel?.font = Font2
        startButton.setBackgroundImage(buttonImage, forState: .Normal)
        startButton.frame = CGRectMake( (ScreenWidth-buttonImage.size.width)/2, ScreenHeight*3/4, buttonImage.size.width, buttonImage.size.height/2)
        startButton.alpha = 0.8
        startButton.hidden = true
        startButton.enabled = true
        self.addSubview(startButton)
        
        //the help button
        self.exitButton = UIButton(type: .Custom)
        exitButton.setTitle("יציאה", forState:.Normal)
        exitButton.titleLabel?.font = Font2
        exitButton.setBackgroundImage(buttonImage, forState: .Normal)
        exitButton.frame = CGRectMake( 10, 10, buttonImage.size.width/3, buttonImage.size.height/3)
        exitButton.alpha = 0.8
        exitButton.enabled = true
        self.addSubview(exitButton)


    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // let touches through and only catch the ones on buttons
        let hitView = super.hitTest(point, withEvent: event)
        
        if hitView is UIButton {
            return hitView
        }
        return nil
    }

}
