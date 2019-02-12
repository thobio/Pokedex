//
//  PokemonDataModel.swift
//  Pokedex
//
//  Created by Thobio on 08/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit

class PokemonDataModel {
    
    //Declare your model variables here
    var id : Int = 0
    var name:String?
    var image : String?
    var type : [String] = []
    var height:String?
    var weight :String?
    var candy :String?
    var num :String?
    var weaknesses : [String] = []
    var nextEvolutions : [nextEvolution]?
}

class nextEvolution {
    var num:Int = 0
    var name:String?
}
