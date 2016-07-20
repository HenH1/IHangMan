//
//  Champ.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/16/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import Foundation

class Champ {
    private var _userId: String! = ""
    private var _name: String! = ""
    private var _score: String! = ""
    
    
    var userId: String {
        return _userId
    }
    
    var name: String {
        get {
        return _name
        }
        set {
            _name = newValue
        }
    }
    
    var score: String {
        return _score
    }
    
    init(name: String, score: String){
        self._score = score
        self._name = name
    }
    
    init(champKey: String, dictionary: Dictionary<String, AnyObject>){
        
        if let score = dictionary["score"]  {
            self._score = String(score)
        }
        
        if let userId = dictionary["userId"] {
            self._userId = String(userId)
        }
        
        
        if let name = dictionary["userName"] as? String {
            self._name = name
        }
        
    }
}
