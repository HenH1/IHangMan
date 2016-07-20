//
//  HangmanView.swift
//  gameHang
//
//  Created by Hen Hershko on 12/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import Foundation
import UIKit

class HangmanView: UIImageView {
    
    //this should never be called
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    
    init(countError: Int) {
        let image = UIImage(named: "\(countError)")!
        super.init(image:image)
        self.frame = CGRectMake(ScreenWidth*2/3, ScreenHeight/2, image.size.width/3 , image.size.height/3 )
        self.layer.shadowOpacity = 1.0
        self.superview?.bringSubviewToFront(self)
    }
    func setVImage(countError: Int)
    {
        let image = UIImage(named: "\(countError)")!
        super.image = image
        self.frame = CGRectMake(ScreenWidth*2/3, ScreenHeight/2, image.size.width/3 , image.size.height/3 )
    }
}