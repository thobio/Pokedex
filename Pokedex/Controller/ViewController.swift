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
    let pokemonCURD = PokemonListCURD()
    
    //MARK: - viewLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transparentNavigationBar()
        if (UserDefaults.standard.bool(forKey: "firstUse")){
            pokemonSortedListFunction()
        }else{
            getPokemonData(url: "https://raw.githubusercontent.com/Biuni/PokemonGo-pokedex/master/pokedex.json")
            UserDefaults.standard.set(true, forKey: "firstUse")
        }
        
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
    
    func updatePokemonData(json: JSON){
        let pokemonJSON = json["pokemon"]
        pokemonCURD.createFunc(pokemonJSON: pokemonJSON)
        pokemonSortedListFunction()
    }
    
    //MARK:- TableViewDataSoure and TableViewDelegete
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonSortedList.count
    }
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
    
    //MARK:- GroupPokemonList
    
    func pokemonSortedListFunction(){
        pokemonList = pokemonCURD.readFunc()
        self.pokemonSortedList = pokemonCURD.groupPokeList(pokeList: pokemonList)
    }
    
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "details"){
            let vc = segue.destination as! DetailsViewController
            let indexpath = self.tableViews.indexPathForSelectedRow
            vc.candy = pokemonSortedList[(indexpath?.row)!].candy
            vc.id = pokemonSortedList[(indexpath?.row)!].id
        }
    }
}


