//
//  CategoryView.swift
//  gameHang
//
//  Created by Hen Hershko on 13/07/2016.
//  Copyright © 2016 Hen Hershko. All rights reserved.
//

import UIKit

class CategoryView: UILabel {
    
    //this should never be called
    required init?(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.08)
        self.font = Font2Big
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    //set category name
    func setCategoty(categoryName:String) {
        self.text = " קטגוריה:" + categoryName
    }
}