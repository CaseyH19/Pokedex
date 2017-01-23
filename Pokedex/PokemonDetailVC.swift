//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Casey on 1/11/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit



class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pokemon: Pokemon!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var defense: UILabel!
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var pokedex: UILabel!
    
    @IBOutlet weak var baseattack: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var speed: UILabel!
    
    @IBOutlet weak var basehp: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var defenseLbl: UILabel!
    
    @IBOutlet weak var heightLbl: UILabel!
    
    @IBOutlet weak var pokeIDLbl: UILabel!
    
    @IBOutlet weak var weightLbl: UILabel!
    
    @IBOutlet weak var attackLbl: UILabel!
    
    @IBOutlet weak var speedLbl: UILabel!
    
    @IBOutlet weak var hpLbl: UILabel!
    
    
    @IBOutlet weak var firstImage: UIImageView!
    
    @IBOutlet weak var sameImage: UIImageView!
    
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var nextEvolLbl: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.layer.cornerRadius = 5.0

        
        
        nameLbl.text = pokemon.name.capitalized
        pokeIDLbl.text = "\(pokemon.pokedexId)"
        mainImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        sameImage.image = UIImage(named: "\(self.pokemon.pokedexId)")

        pokemon.downloadPokeDetails {
            //print("Did arrive")
            //will only be called after network call is complete
            self.updateUI()
            //initializeTableViewPopover()
            
        }
    
    }

    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        speedLbl.text = pokemon.speed
        hpLbl.text = pokemon.hp
        
        //print(pokemon.movs.count)
        
        if pokemon.nextEvolId == "" && pokemon.preEvolID == ""{
            nextEvolLbl.text = "No Evolutions"
            secondImage.isHidden = true
            firstImage.isHidden = true
            
        } else if pokemon.preEvolID == "" {
            firstImage.isHidden = true
            secondImage.isHidden = false
            secondImage.image = UIImage(named: pokemon.nextEvolId)
            let textString = "Next Evolution: \(pokemon.nextEvolName) - LVL: \(pokemon.nextEvolLvl)"
            nextEvolLbl.text = textString
        }else if pokemon.nextEvolId == "" {
            secondImage.isHidden = true
            firstImage.isHidden = false
            firstImage.image = UIImage(named: pokemon.preEvolID)
            
            nextEvolLbl.text = "Evolved from: \(pokemon.preEvolName) No More Evolutions"
        }
        else {
            secondImage.isHidden = false
            firstImage.isHidden = false
            firstImage.image = UIImage(named: pokemon.preEvolID)
            secondImage.image = UIImage(named: pokemon.nextEvolId)
            let textString = "Next Evolution: \(pokemon.nextEvolName) - LVL: \(pokemon.nextEvolLvl)"
            nextEvolLbl.text = textString
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func segmentView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            attackLbl.isHidden = false
            defenseLbl.isHidden = false
            heightLbl.isHidden = false
            weightLbl.isHidden = false
            descriptionLbl.isHidden = false
            typeLbl.isHidden = false
            pokeIDLbl.isHidden = false
            type.isHidden = false
            defense.isHidden = false
            height.isHidden = false
            pokedex.isHidden = false
            baseattack.isHidden = false
            weight.isHidden = false
            speed.isHidden = false
            speedLbl.isHidden = false
            hpLbl.isHidden = false
            basehp.isHidden = false
            tableview.isHidden = true
        }
        if sender.selectedSegmentIndex == 1 {
            attackLbl.isHidden = true
            defenseLbl.isHidden = true
            heightLbl.isHidden = true
            weightLbl.isHidden = true
            descriptionLbl.isHidden = true
            typeLbl.isHidden = true
            pokeIDLbl.isHidden = true
            type.isHidden = true
            defense.isHidden = true
            height.isHidden = true
            pokedex.isHidden = true
            baseattack.isHidden = true
            weight.isHidden = true
            speed.isHidden = true
            speedLbl.isHidden = true
            hpLbl.isHidden = true
            basehp.isHidden = true
            tableview.reloadData()
            tableview.isHidden = false
        }
        
    }
    
    //3 required delegate methods (MEMORIZE!!!)
    //number of columns
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.movs.count
        
    }
    
    //recycles data when scrolling
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath) as? MoveCell
        {

            cell.configureCell(pokemon: pokemon, row: indexPath.row)
            
            return cell
            
        } else {
            return MoveCell()
        }
        
    }
    
   


    
  

}
