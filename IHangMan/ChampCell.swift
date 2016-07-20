//
//  ChampCell.swift
//  IHangMan
//
//  Created by Amit Nahmani on 7/14/16.
//  Copyright © 2016 Amit Nahmani. All rights reserved.
//

import UIKit

class champCell: UITableViewCell {
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    var champ: Champ!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
    func configureCell(champ: Champ, id: String) {
       
        self.champ = champ
        
        idLbl.text = id
        nameLbl.text = champ.name
        scoreLbl.text = champ.score
    }
    
    
    
}