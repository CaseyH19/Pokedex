//
//  MoveCell.swift
//  Pokedex
//
//  Created by Casey on 1/12/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {

    @IBOutlet weak var moveName: UILabel!
    
    @IBOutlet weak var lvlLearned: UILabel!
    
    func configureCell(pokemon: Pokemon, row: Int) {
       moveName.text = "Move: \(pokemon.movs[row])"
       lvlLearned.text = "Level Learned: \(pokemon.lvls[row])"
        
        
    }

}
