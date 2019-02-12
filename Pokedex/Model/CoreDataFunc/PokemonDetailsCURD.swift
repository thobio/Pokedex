//
//  PokemonDetailsCURD.swift
//  Pokedex
//
//  Created by Thobio on 12/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import CoreData

class PokemonDetailsCURD {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func createFunction(){
        
    }
    
    func updateFunction(){
        
    }
    
    func readFunction(candy:String,vc:UIViewController) -> [PokemonDex]{
        let context = appDelegate.persistentContainer.viewContext
        var pokemons: [PokemonDex] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonDex")
        request.predicate = NSPredicate(format: "candy = %@", candy)
        do{
            let result = try context.fetch(request)
            pokemons = result as! [PokemonDex]
        } catch {
            print("Failed")
        }
        return pokemons
    }
    
    func deleteFunction(){
        
    }
    
    func typesReadData(data:NSSet) -> [String]{
        var dataOftype : [String] = []
        for types in  data{
            let value = types as! NSManagedObject
            dataOftype.append((value.value(forKey: "types") as! String))
        }
        return dataOftype
    }
    
}
