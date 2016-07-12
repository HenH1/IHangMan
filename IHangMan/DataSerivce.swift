//
//  DataSerivce.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/9/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import Foundation
import Firebase

class DataSerivce {
    static let ds = DataSerivce()
    
    private let _BASE_REF = FIRDatabase.database().reference()
    
    //private let _USERS_REF = FIRDatabase.database().reference().childByAppendingPath("users")
    //private let _GAMES_REF = FIRDatabase.database().reference().childByAppendingPath("games")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
   /*
    var USERS_REF: FIRDatabaseReference {
        return _USERS_REF
    }
    
    
    var GAMES_REF: FIRDatabaseReference {
        return _GAMES_REF
    }
    */

}