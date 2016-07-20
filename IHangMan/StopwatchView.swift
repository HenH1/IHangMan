//
//  StopwatchView.swift
//  gameHang
//
//  Created by Hen Hershko on 11/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import UIKit

class StopwatchView: UILabel {
    
    //this should never be called
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.font = Font2
    }
    
    //helper method that implements time formatting
    //to an int parameter (eg the seconds left)
    func setSeconds(seconds:Int) {
        self.text = String(format: " %02i:%02i", seconds/60, seconds % 60)
    }
}
