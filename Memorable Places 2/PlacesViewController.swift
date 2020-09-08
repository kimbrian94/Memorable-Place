//
//  PlacesViewController.swift
//  Memorable Places 2
//
//  Created by Brian Kim on 2020-07-03.
//  Copyright © 2020 Brian Kim. All rights reserved.
//

import UIKit
import CoreLocation

var places = [Dictionary<String, String>()]
var activeRow = -1

class PlacesViewController: UITableViewController {
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let arrayObject = UserDefaults.standard.object(forKey: "places") {
            if let tempArray = arrayObject as? [Dictionary<String, String>] {
                places = tempArray
            }
        }
        
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append(["name":"Taj Mahal", "lat":"27.175277", "lon":"78.042128"])
            UserDefaults.standard.set([["name":"Taj Mahal", "lat":"27.175277", "lon":"78.042128"]], forKey: "places")
        }
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activeRow = -1
        table.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil {
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeRow = indexPath.row
        //print(locationArray.count)
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let arrayObject = UserDefaults.standard.object(forKey: "places")
            var array: [Dictionary<String, String>]
            if let tempArray = arrayObject as? [Dictionary<String, String>] {
                array = tempArray
                array.remove(at: indexPath.row)
                UserDefaults.standard.set(array, forKey: "places")
            }
            
            places.remove(at: indexPath.row)
            table.reloadData()
        }
    }
}
