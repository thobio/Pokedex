//
//  PokemonListCURD.swift
//  Pokedex
//
//  Created by Thobio on 12/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class PokemonListCURD {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func createFunc(pokemonJSON:JSON) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        for i in 0..<pokemonJSON.count {
            let pokemon = pokemonJSON[i]
            let newPokemon = PokemonDex(context: context)
            newPokemon.id = Int16(pokemon["id"].intValue)
            newPokemon.name = pokemon["name"].stringValue
            newPokemon.image = pokemon["img"].stringValue
            newPokemon.candy = pokemon["candy"].stringValue
            newPokemon.num = pokemon["num"].stringValue
            for j in 0..<pokemon["type"].count {
                let typesPoke = Type(context: context)
                typesPoke.types = pokemon["type"][j].stringValue
                newPokemon.addToTypes(typesPoke)
            }
            newPokemon.weight = pokemon["weight"].stringValue
            newPokemon.height = pokemon["height"].stringValue
            for k in 0..<pokemon["weaknesses"].count {
                let weaknesses = Weaknesses(context: context)
                weaknesses.weaknesses = pokemon["weaknesses"][k].stringValue
                newPokemon.addToWeaknessespok(weaknesses)
            }
            let pokemonNextEvolution = pokemon["next_evolution"]
            for l in 0..<pokemonNextEvolution.count {
                let nextEvolutions = nextEvolution()
                nextEvolutions.num = pokemonNextEvolution[l]["num"].stringValue
                nextEvolutions.name = pokemonNextEvolution[l]["name"].stringValue
                let evolutonsPokemon = Next_Evolution(context: context)
                evolutonsPokemon.num = pokemonNextEvolution[l]["num"].stringValue
                evolutonsPokemon.name = pokemonNextEvolution[l]["name"].stringValue
                newPokemon.addToNextEv(evolutonsPokemon)
            }
            appDelegate.saveContext()
        }
        
    }
    
    func updateFunc() {
        
    }
    
    func readFunc() -> [PokemonDataModel]{
        var pokemons:[PokemonDataModel] = []
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDex")
            do{
                let result = try context.fetch(request)
                    for pokemon in result as! [PokemonDex] {
                        let pokemonData = PokemonDataModel()
                        pokemonData.id = Int(pokemon.id)
                        pokemonData.name = pokemon.name
                        pokemonData.image = pokemon.image
                        pokemonData.candy = pokemon.candy
                        pokemonData.num = pokemon.num
                        pokemonData.weight = pokemon.weight
                        pokemonData.height = pokemon.height
                        for types in pokemon.types! {
                            let value = types as! NSManagedObject
                            pokemonData.type.append(value.value(forKey: "types") as! String)
                        }
                        for weakness in pokemon.weaknessespok! {
                            let value = weakness as! NSManagedObject
                            pokemonData.weaknesses.append(value.value(forKey: "weaknesses") as! String)
                        }
                        for nextEvolutions in pokemon.nextEv! {
                            let value = nextEvolutions as! NSManagedObject
                            
                            let nextEVt = nextEvolution()
                            nextEVt.num = (value.value(forKey: "num") as! String)
                            nextEVt.name = (value.value(forKey: "name") as! String)
                            
                            pokemonData.nextEvolutions?.append(nextEVt)
                        }
                        pokemons.append(pokemonData)
                    }
            } catch {
                print("Failed")
            }
        return pokemons
    }
    
    func deleteFunc(){
        
    }
    
    func groupPokeList(pokeList:[PokemonDataModel]) -> [PokemonDataModel] {
        var pokemonSortedList : [PokemonDataModel] = []
        var candyTemp : String?
        for i in 0..<pokeList.count {
            let pokemons = pokeList[i]
            if candyTemp != nil {
                if pokemons.candy == candyTemp {
                            // nothing to add here
                }
                else if pokemons.candy == "None" {
                    pokemonSortedList.append(pokemons)
                }else{
                    pokemonSortedList.append(pokemons)
                    candyTemp = pokemons.candy
                }
            }else{
                    candyTemp = pokemons.candy
                    pokemonSortedList.append(pokemons)
            }
        }
        return pokemonSortedList
    }
    
}
