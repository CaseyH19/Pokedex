//
//  ViewController.swift
//  Pokedex
//
//  Created by Casey on 1/9/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    //Data source holds data
    //flowlayout sets setting for layout
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filteredPoke = [Pokemon]()
    var inSearchMode = false
    //to play music
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        //hides the keyboard when tap outside of textfield
        //self.hideKeyboard()
        
        //change key on teh keyboard to done instead of search
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    //sets up audio file
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            //infinite loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //parses csv
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            //gets rows of the csv file
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print("ROWS: \(rows)")
            
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeID)
                pokemon.append(poke)
                
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }

    //required
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //only loads cells that are going to be displayed and reuses when not in view
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPoke[indexPath.row]
                cell.configureCell(poke)

            }else {
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)

            }
            //sets label and image to pokemon
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    //when selecting a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        if inSearchMode {
            poke = filteredPoke[indexPath.row]
            
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    //num of objects
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPoke.count
        } else {
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //sets size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 103, height: 103)
        
    }
    
    //controls music
    @IBAction func musicBtn(_ sender: UIButton) {
        //if its playing it will be paused
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
            //else it will play
        else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
        
    }
    
    //when typing in searchbar(any keystroke)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            //filters full pokemon based on name contains text
            //$0 is placeholder for every item in array
            filteredPoke = pokemon.filter({$0.name.range(of: lower) != nil})
            //reloads collectionview
            collection.reloadData()
        }
    }
    
    //when search is clicked the keyboard will disappear
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //hapens before segue and set up data to be passed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if its pokemondeatil
        if segue.identifier == "PokemonDetailVC" {
            
            if let detailsVC = segue.destination as? PokemonDetailVC {
                //sender is a pokemon class
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    
    
    
    
}

//to hide keyboard
//extension UIViewController
//{
//    
//    func hideKeyboard()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(UIViewController.dismissKeyboard))
//        
//        
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard()
//    {
//        view.endEditing(true)
//    }
//}




