//
//   SharedData.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/10/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import Foundation
/*
class SharedData {
    static let sd = SharedData()
    
    private let _defaults = NSUserDefaults.standardUserDefaults()
    
    
    var defaults: NSUserDefaults {
        return _defaults
    }
  */


class SharedData: User {
    struct Singleton {
        static var instance : User = {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let user =  User(
                email: defaults.objectForKey("email") as? String,
            )
            return user
        }()
    }
    
    return Singleton.instance
}
