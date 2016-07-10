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
    
    private let _ref = FIRDatabase.database().reference()
    
    var Ref: FIRDatabaseReference {
        return _ref
    }
}