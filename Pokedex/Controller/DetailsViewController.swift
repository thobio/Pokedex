//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Thobio on 11/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import CoreData
import MapleBacon
import Neon

class DetailsViewController: UIViewController {
    
    var candy :String?
    var id :Int = 0
    var pokemons : [PokemonDex] = []
    let pokemonDetail = PokemonDetailsCURD()
    
    @IBOutlet var viewOnTable: UIView!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var pokemonName: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        pokemons = pokemonDetail.readFunction(candy: candy!, vc: self)
        pokemonsDisplay()
    }

    func pokemonsDisplay() {
        for pokemon in pokemons {
            if pokemon.id == id {
                self.pokemonName.text = pokemon.name
                self.pokemonImage.setImage(with: URL(string: pokemon.image!))
                let data = pokemonDetail.typesReadData(data: pokemon.types!)
                //typeDisplayLabel(dataType: data)
            }
        }
    }
    
    //TODO:- need to complete it
    func typeDisplayLabel(dataType:[String]) {
        let mainStackView = UIStackView()
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        mainStackView.backgroundColor = .black
        for i in 0..<dataType.count {
            let labelText = UILabel()
            labelText.text = dataType[i]
            labelText.backgroundColor = UIColor.red
            mainStackView.addArrangedSubview(labelText)
        }
        self.viewOnTable.addSubview(mainStackView)
    }

}
