//
//  ViewController.swift
//  Pokedex
//
//  Created by Thobio on 07/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapleBacon
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableViews: UITableView!
    var pokemonList : [PokemonDataModel] = []
    var pokemonSortedList : [PokemonDataModel] = []
    var candyTemp : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - viewLoad
    /***************************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transparentNavigationBar()
         
        getPokemonData(url: "https://raw.githubusercontent.com/Biuni/PokemonGo-pokedex/master/pokedex.json")
        self.tableViews.dataSource = self
        self.tableViews.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: - Networking
    /***************************************************************/
    //Write the getPokemonData method here:
    func getPokemonData(url:String) {
        Alamofire.request(url, method: .get, parameters:nil, encoding: URLEncoding.default, headers:nil).responseJSON { (response) in
            if response.result.isSuccess {
                let pokemonJSON:JSON = JSON(response.result.value!)
                self.updatePokemonData(json: pokemonJSON)
                self.tableViews.reloadData()
            }else{
                print("Connection Issues")
            }
        }
    }
    //MARK: - JSON Parsing
    /***************************************************************/
    //Write the updatePokemonData method here:
    func updatePokemonData(json: JSON){
        let pokemonJSON = json["pokemon"]
        let context = appDelegate.persistentContainer.viewContext
        for i in 0..<pokemonJSON.count {
            let pokemon = pokemonJSON[i]
            let newPokemon = PokemonDex(context: context)
            
            let pokemonDataModel = PokemonDataModel()
            pokemonDataModel.id = pokemon["id"].intValue
            pokemonDataModel.name = pokemon["name"].stringValue
            pokemonDataModel.image = pokemon["img"].stringValue
            pokemonDataModel.candy = pokemon["candy"].stringValue
            pokemonDataModel.num = pokemon["num"].stringValue
            
            newPokemon.id = Int16(pokemon["id"].intValue)
            newPokemon.name = pokemon["name"].stringValue
            newPokemon.image = pokemon["img"].stringValue
            newPokemon.candy = pokemon["candy"].stringValue
            newPokemon.num = pokemon["num"].stringValue
          
            
                for j in 0..<pokemon["type"].count {
                    
                    pokemonDataModel.type.append(pokemon["type"][j].stringValue)
                    
                    let typesPoke = Type(context: context)
                    typesPoke.types = pokemon["type"][j].stringValue
                    newPokemon.addToTypes(typesPoke)
                    
                }
            pokemonDataModel.height = pokemon["height"].stringValue
            pokemonDataModel.weight = pokemon["weight"].stringValue
            
            newPokemon.weight = pokemon["weight"].stringValue
            newPokemon.height = pokemon["height"].stringValue
            
                for k in 0..<pokemon["weaknesses"].count {
                    
                    pokemonDataModel.weaknesses.append(pokemon["weaknesses"][k].stringValue)
                    
                    let weaknesses = Weaknesses(context: context)
                    weaknesses.weaknesses = pokemon["weaknesses"][k].stringValue
                    newPokemon.addToWeaknessespok(weaknesses)
                    
                }
            let pokemonNextEvolution = pokemon["next_evolution"]
                for l in 0..<pokemonNextEvolution.count {
                    
                    let nextEvolutions = nextEvolution()
                    nextEvolutions.num = pokemonNextEvolution[l]["num"].intValue
                    nextEvolutions.name = pokemonNextEvolution[l]["name"].stringValue
                    pokemonDataModel.nextEvolutions?.append(nextEvolutions)
                    
                    let evolutonsPokemon = Next_Evolution(context: context)
                    evolutonsPokemon.num = pokemonNextEvolution[l]["num"].stringValue
                    evolutonsPokemon.name = pokemonNextEvolution[l]["name"].stringValue
                    
                    newPokemon.addToNextEv(evolutonsPokemon)
                }
            pokemonList.append(pokemonDataModel)
            appDelegate.saveContext()
        }
        pokemonSortedListFunction()
    }
    //MARK:- TableViewDataSoure and TableViewDelegete
    /******************************************************************/
    //Write the scrollViewDidScroll method here :
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if(offset > 10){
            let alphas = min(1, 1-((10 + 64 - offset)/64))
            navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1).withAlphaComponent(alphas))
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }else{
            navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor:  UIColor(red: 0/255, green: 175/255, blue: 240/255, alpha: 1).withAlphaComponent(0))
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    }
    //Write the numberOfRowsInSection method here :
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonSortedList.count
    }
    //Write the cellForRowAt method here :
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListTableViewCell
            let pokemons = pokemonSortedList[indexPath.row]
            cell.imageViews.setImage(with: URL(string: pokemons.image!))
            cell.titleLabel.text = pokemons.name
            cell.subtitle.text = pokemons.candy

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
        tableViews.reloadData()
    }
    //Write the pokemonSortedListFunction method here:
    func pokemonSortedListFunction(){
        for i in 0..<self.pokemonList.count {
            let pokemons = self.pokemonList[i]
            if self.candyTemp != nil {
                if pokemons.candy == self.candyTemp {
                    // nothing to add here
                }
                else if pokemons.candy == "None" {
                    self.pokemonSortedList.append(pokemons)
                }else{
                    self.pokemonSortedList.append(pokemons)
                    self.candyTemp = pokemons.candy
                }
            }else{
                self.candyTemp = pokemons.candy
                self.pokemonSortedList.append(pokemons)
            }
        }
    }
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "details"){
            let vc = segue.destination as! DetailsViewController
            let indexpath = self.tableViews.indexPathForSelectedRow
            vc.candy = pokemonSortedList[(indexpath?.row)!].candy
            vc.id = pokemonSortedList[(indexpath?.row)!].id
        }
    }
}


