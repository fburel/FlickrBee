//
//  CitiesViewController.swift
//  FlickrBee
//
//  Created by florian BUREL on 25/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesViewController: UIViewController, UITableViewDataSource {
    
    let CELL_ID_1 = "IDENTIFIED_CITY_CELL"
    let CELL_ID_2 = "UNIDENTIFIED_CITY_CELL"
    
    @IBOutlet weak var tableView: UITableView!
    
    var cities : [City]!
    
    let repository = CitiesRepository()
    
    // TODO 4 :Recuperer la liste des city du repository dans cities
    // TODO 5 : Ajouter un bout de code temporaire qui, si cities est vide apres recuperation des data, ajoute Lisbonne, Athenes et Vilnius a la db.
    override func viewDidLoad()
    {
      
        super.viewDidLoad()
        
        self.cities = repository.selectAllCities()
        
        self.tableView.dataSource = self
        
        if(self.cities.isEmpty)
        {
            repository.addCity("Lisbonne", latitude: 38.71, longitude: -9.14)
            repository.addCity("Athenes", latitude: 37.966667, longitude: 23.716667)
            repository.addCity("Vilnius", latitude: 54.683, longitude: 25.267)
            self.cities = repository.selectAllCities()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    // TODO 6 : mettre a jour cette methode
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cities.count
    }
    
    // TODO 7 : mettre a jour cette methode
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let city = self.cities[indexPath.row]
        
        if city.name == ""
        {
            return tableView.dequeueReusableCellWithIdentifier(CELL_ID_2, forIndexPath: indexPath) 
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID_1, forIndexPath: indexPath) 
        
        
        
        cell.textLabel!.text = city.name
        
        cell.detailTextLabel!.text = "(latitude : \(city.latitude) - longitude : \(city.longitude))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let city = self.cities[indexPath.row]
        self.repository.deleteCity(city)
        
        self.cities.removeAtIndex(indexPath.row)
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        switch(segue.identifier!)
        {
            case "CITY_SELECTED":
            
                // Recuperer la ville selectionné
                
                let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
                let city = self.cities[indexPath!.row]
                
                // Recuperer le photoVC
                let photoVC = segue.destinationViewController as! PhotosViewController
            
                // Construire un FlickrLocation et le passé au PhotosVC
                photoVC.locationToDisplay = FlickrLocation(longitude: city.longitude.doubleValue, latitude: city.latitude.doubleValue)
            
        case "ADD_CITY":
            
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.completionHandler = { (locationOrNil) in
                
                if let location = locationOrNil
                {
                    let city = self.repository.addCity("", latitude: location.latitude, longitude: location.longitude)
                    self.cities = self.repository.selectAllCities()
                    self.tableView.reloadData()
                    
                    self.startReverseGeocodingForCity(city!)
                    
                }
                
                // fermer l'ecran mapview
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            
        default:
            print("error")
        }
    }
    
    func startReverseGeocodingForCity(city:City)
    {
        let geocoder = CLGeocoder()
        
        let location = CLLocation(latitude: city.latitude.doubleValue, longitude: city.longitude.doubleValue)
        
        geocoder.reverseGeocodeLocation(location){ (results, error) in
            
            if let placemarks = results,
                let firstResult = placemarks.first
            {
                city.name = firstResult.locality!
                self.tableView.reloadData()
            }
            
        }
    }
}
