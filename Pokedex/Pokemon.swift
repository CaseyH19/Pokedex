//
//  Pokemon.swift
//  Pokedex
//
//  Created by Casey on 1/9/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _speed: String!
    private var _hp: String!
    private var _nextEvolTxt: String!
    private var _nextEvolName: String!
    private var _nextEvolID: String!
    private var _preEvolID: String!
    private var _preEvolName: String!
    private var _nextEvolLvl: String!
    private var _pokemonURL: String!
    
    var movs = [String]()
    var lvls = [String]()
    var movsLvls = [String: Int]()
    typealias moveTuple = (key: String, value: Int)
    
    var tupleArray: [moveTuple] = []
    
    var preEvolID: String {
        if _preEvolID == nil {
            _preEvolID = ""
            
        }
        return _preEvolID
    }
    
    var preEvolName: String {
        if _preEvolName == nil {
            _preEvolName = ""
            
        }
        return _preEvolName
    }
    
    var nextEvolName: String {
        if _nextEvolName == nil {
            _nextEvolName = ""
        }
        return _nextEvolName
    }
    
    var nextEvolId: String {
        if _nextEvolID == nil {
            _nextEvolID = ""
        }
        return _nextEvolID
    }
    
    var nextEvolLvl: String {
        if _nextEvolLvl == nil {
            _nextEvolLvl = ""
        }
        return _nextEvolLvl
    }
    
    var nextEvolTxt: String {
        if _nextEvolTxt == nil {
            _nextEvolTxt = ""
        }
        return _nextEvolTxt
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        if _weight == "0" {
            _weight = "Unknown"
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        if _height == "0" {
            _height = "Unknown"
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = "Pokémon"
        }
        return _type
    }
    
    var speed: String {
        if _speed == nil {
            _speed = ""
        }
        return _speed
    }
    
    var hp: String {
        if _hp == nil {
            _hp = ""
        }
        return _hp
    }
    
    var description: String {
        if _description == nil {
            _description = "Gathering Info on \(self.name.capitalized)..."
        }
        return _description
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokeDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            //print(response.result.value)
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    for x in 0..<stats.count {
                        if let stat = stats[x]["stat"] as? Dictionary<String, AnyObject> {
                            if let nameStat = stat["name"] as? String {
                                let stt = nameStat
                                if stt == "defense" {
                                    if let baseStatDef = stats[x]["base_stat"] as? Int {
                                        self._defense = "\(baseStatDef)"
                                    }
                                }
                                if stt == "attack" {
                                    if let baseStatAtt = stats[x]["base_stat"] as? Int {
                                        self._attack = "\(baseStatAtt)"
                                    }
                                }
                                if stt == "speed" {
                                    if let baseStatSp = stats[x]["base_stat"] as? Int {
                                        self._speed = "\(baseStatSp)"
                                    }
                                }
                                if stt == "hp" {
                                    if let baseStathp = stats[x]["base_stat"] as? Int {
                                        self._hp = "\(baseStathp)"
                                    }
                                }
                            }
                        }
                    }
                }
                

                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] , types.count > 0
                {

                    if let type = types[0]["type"] as? Dictionary<String, String> {
                        if let nameType = type["name"] {
                            self._type = nameType.capitalized
                        }
                    }
                    //if there are more than one type
                    if types.count > 1{
                        //loops thorugh the number of times
                        for x in 1..<types.count {
                            if let type = types[x]["type"] as? Dictionary<String, String> {
                                if let nameType = type["name"] {
                                    self._type! += "/\(nameType.capitalized)"
                                }
                            }

                        }
                    }
                    
                } else {
                    self._type = "Unknown"
                    
                }
                
                //fix url to add pokedexID
                let descripURL = "\(oldVersionURL)\(self.pokedexId)"
                
                Alamofire.request(descripURL).responseJSON(completionHandler: {
                    (response) in
                    if let dic = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let descArr = dic["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
        
                            if let URL = descArr[0]["resource_uri"] {
        
                                let descURL = "\(URL_BASE)\(URL)"
                                //print(descURL)
        
                                Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                                    if let descriptDict = response.result.value as? Dictionary<String, AnyObject> {
                                        if let descript = descriptDict["description"] as? String {
                                            let newDescript = descript.replacingOccurrences(of: "POKMON", with: "Pokémon")
        
                                            self._description = newDescript
                                            //print(newDescript)
                                            //print(self.description)
                                        }
                                    }
                                    completed()
                                })
                            }
        
        
                            if descArr.count > 1 {
        
                                if let URL2 = descArr[1]["resource_uri"] {
        
                                    let desURL = "\(URL_BASE)\(URL2)"
                                    //print(descURL)
        
                                    Alamofire.request(desURL).responseJSON(completionHandler: { (response) in
                                        if let descriptDic = response.result.value as? Dictionary<String, AnyObject> {
                                            if let desc = descriptDic["description"] as? String {
                                                let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokémon")
                                                
                                                self._description! += " \(newDesc)"
                                                
                                            }
                                        }
                                        
                                       completed()
                                    })
                                }
                            }
                            
                        } else {
                            self._description = "Nothing is known about this Pokémon"
                        }
                        
                        if let moves = dic["moves"] as? [Dictionary<String, AnyObject>] , moves.count > 0 {
                            //print("Number of moves: \(moves.count)")
                            for x in 0..<moves.count {
                                
                                if let lvl = moves[x]["level"] as? Int {
                                    //print("Arrived")
                                    let movLvl = lvl
                                    //print(movLvl)
                                    self.lvls.append("\(movLvl)")
        
                                    if let movName = moves[x]["name"] as? String {
                                        let nmMov = movName
                                        self.movs.append(nmMov)
                                        //print("\(nmMov): \(movLvl)")
                                        //self.movsLvls[nmMov] = movLvl
                                        
                                    }
                                    
                                }
                            }
                        
                        }
                    }
                    completed()
                })
                
                let speciesURL: String!
                if let species = dict["species"] as? Dictionary<String, String> {
                    if let urlSp = species["url"] {
                        speciesURL = urlSp
                        Alamofire.request(speciesURL).responseJSON(completionHandler: {
                            (response) in
                            if let newdic = response.result.value as? Dictionary<String, AnyObject> {
                                if let preEvo = newdic["evolves_from_species"] as? Dictionary<String, String> {
                                    if let preEvId = preEvo["url"] {
                                        let newStr = preEvId.replacingOccurrences(of: "http://pokeapi.co/api/v2/pokemon-species/", with: "")
                                        let preId = newStr.replacingOccurrences(of: "/", with: "")
                                        self._preEvolID = preId
                                        if let preEName = preEvo["name"] {
                                            self._preEvolName = preEName.capitalized
                                        }
                                    }
                                }
                                
                                if let chain = newdic["evolution_chain"] as? Dictionary<String, String> {
                                    if let url = chain["url"] {
                                        Alamofire.request(url).responseJSON(completionHandler: {
                                            (response) in
                                            if let newdic = response.result.value as? Dictionary<String, AnyObject> {
                                                if let chain = newdic["chain"] as? Dictionary<String, AnyObject> {
                                                    self.evolution(evol: chain)
                                                    
                                                }
                                            }
                                            completed()
                                        })
                                    }
                                }
                            }
                            completed()
                        })
                    }
                }
               
                
                
            }
            completed()
        }
    }
    
    
    
    
    
    func evolution(evol: Dictionary<String, AnyObject>) {
        //print(evol)
        if let evolChain = evol["evolves_to"] as? [Dictionary<String, AnyObject>] {
            
            if evolChain.count == 1 {
                if let evo = evolChain[0]["evolves_to"] as? [Dictionary<String, AnyObject>] {
                    
                    if evo.count == 0 {
                        //print(evo)
                        if let spc = evolChain[0]["species"] as? Dictionary<String, String> {
                            if let nam = spc["name"] {
                                if nam != self.name {
                                    self._nextEvolName = nam.capitalized
                                    if let url = spc["url"] {
                                        let newStr = url.replacingOccurrences(of: "http://pokeapi.co/api/v2/pokemon-species/", with: "")
                                        let evolId = newStr.replacingOccurrences(of: "/", with: "")
                                        self._nextEvolID = evolId
                                        if let dets = evolChain[0]["evolution_details"] as? [Dictionary<String, AnyObject>] {
                                            if let lv = dets[0]["min_level"] as? Int {
                                                self._nextEvolLvl = "\(lv)"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else if evo.count >= 1 {
                        if let pok = evol["species"]?["name"] as? String {
                            if pok == self.name {
                                if let nextPok = evolChain[0]["species"]?["name"] as? String{
                                    //print(nextPok)
                                    self._nextEvolName = nextPok.capitalized
                                    if let url = evolChain[0]["species"]?["url"] as? String {
                                        let newStr = url.replacingOccurrences(of: "http://pokeapi.co/api/v2/pokemon-species/", with: "")
                                        let evId = newStr.replacingOccurrences(of: "/", with: "")
                                        self._nextEvolID = evId
                                    }
                                    if let detLvl = evolChain[0]["evolution_details"] as? [Dictionary<String, AnyObject>]  {
                                        if let lv = detLvl[0]["min_level"] as? Int {
                                            self._nextEvolLvl = "\(lv)"
                                        }
                                    }
                                    
                                }
                            } else {
                                //print(evolChain)
                                if let pok = evolChain[0]["species"]?["name"] as? String {
                                    //print(pok)
                                    if self.name == pok {
                                        if let third = evolChain[0]["evolves_to"] as? [Dictionary<String, AnyObject>] {
                                            if let thirdName = third[0]["species"]?["name"] as? String{
                                                //print(thirdName)
                                                self._nextEvolName = thirdName.capitalized
                                                
                                                if let thirdUrl = third[0]["species"]?["url"] as? String{
                                                    let newStr = thirdUrl.replacingOccurrences(of: "http://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                    let evId = newStr.replacingOccurrences(of: "/", with: "")
                                                    self._nextEvolID = evId
                                                    
                                                    if let thLvl = third[0]["evolution_details"] as? [Dictionary<String, AnyObject>]  {
                                                        if let thirdlv = thLvl[0]["min_level"] as? Int {
                                                            self._nextEvolLvl = "\(thirdlv)"
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    
}
