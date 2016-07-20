//
//  CounterLabelView.swift
//  gameHang
//
//  Created by Hen Hershko on 11/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import UIKit

class CounterLabelView: UILabel {
    var value:Int = 0 {
        didSet {
            self.text = " \(value)"
        }
    }
    
    private var endValue: Int = 0
    private var timer: NSTimer? = nil
    
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(font:frame:")
    }
    
    init(font:UIFont, frame:CGRect) {
        super.init(frame:frame)
        self.font = font
        self.backgroundColor = UIColor.clearColor()

    }
    
    func updateValue(timer:NSTimer) {
        // update the value
        if (endValue < value) {
            value -= 1
        } else {
            value += 1
        }
        
        // stop and clear the timer
        if (endValue == value) {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    //count to a given value
    func setValue(newValue:Int, duration:Float) {
        // set the end value
        endValue = newValue
        
        // cancel previous timer
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        // calculate the interval to fire each timer
        let deltaValue = abs(endValue - value)
        if (deltaValue != 0) {
            var interval = Double(duration / Float(deltaValue))
            if interval < 0.01 && !(interval == 0.0){
                interval = 0.01
            }
            
            // set the timer to update the value
            timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector:#selector(CounterLabelView.updateValue(_:)), userInfo: nil, repeats: true)
        }
    }
}
