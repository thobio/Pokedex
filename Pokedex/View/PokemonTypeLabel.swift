//
//  PokemonTypeLabel.swift
//  Pokedex
//
//  Created by Thobio on 12/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit

class PokemonTypeLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
         layer.cornerRadius = height/2
    }
}
