//
//  CitiesRepository.swift
//  FlickrBee
//
//  Created by florian BUREL on 25/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CitiesRepository
{
    
    let CITY_ENTITY_NAME = "City"
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        
        var ad = UIApplication.sharedApplication().delegate! as? AppDelegate
        var context = ad!.managedObjectContext!
        
        return context
    }()
    
    //TODO 1 : Implementer la méthode (ordered by name)
    // !!! la méthode executeQuery... retourne un [AnyObject] et non un [City] (utiliser le downcast 'as!')
    func selectAllCities() -> Array<City>
    {
        let request = NSFetchRequest(entityName: CITY_ENTITY_NAME)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let result = self.managedObjectContext.executeFetchRequest(request, error: nil)
        
        return result as! [City]
    }
    
    // TODO 2 : Implementer cette méthode
    // Sauvegarder apres l'ajout en bdd (passer nil en erreur)
    func addCity(name:String, latitude:Double, longitude:Double) -> City?
    {
        var city = NSEntityDescription.insertNewObjectForEntityForName(CITY_ENTITY_NAME, inManagedObjectContext: self.managedObjectContext) as! City
        
        city.name = name
        city.longitude = longitude
        city.latitude = latitude
        
        self.managedObjectContext.save(nil)
        
        return city
    }
    
    // TODO 3 : Implementer cette methode (+ sauvegarde)
    func deleteCity(city:City)
    {
        self.managedObjectContext.deleteObject(city)
        self.managedObjectContext.save(nil)
    }
}