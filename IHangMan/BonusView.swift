//
//  BonusView.swift
//  gameHang
//
//  Created by Hen Hershko on 13/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import UIKit

class BonusView: UILabel {
    
    //this should never be called
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.font = FontHUD
    }

    func setBonus(bonus:Int) {
        self.text = String(format: "X%i", bonus)
    }
}
