//
//  FlickrDownloader.swift
//  FlickrBee
//
//  Created by florian BUREL on 24/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import Foundation

struct FlickrLocation {
    
    let longitude:Double
    let latitude:Double
    
    
    
    init(longitude:Double, latitude:Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class FlickrDownloader {
    
    static let Budapest = FlickrLocation(longitude: 19.040833, latitude: 47.498333)
    
    let API_KEY = "c717612cb717ca71c077ab4ff73fc32d"
    
    func fetchPhotosForLocation(location:FlickrLocation, completion:([Photo])->Void)
    {
        let qos = DISPATCH_QUEUE_PRIORITY_HIGH
        
        let global_queue = dispatch_get_global_queue(qos, 0)
        
        dispatch_async(global_queue) {
            
            let p = self.photosForLocation(location)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                completion(p)
                
            }
            
        }

    }
    
    
    
    func photosForLocation(location:FlickrLocation) -> Array<Photo>
    {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(location.latitude)&lon=\(location.longitude)&radius=30&format=json&nojsoncallback=1"
        
        // peut echouer si l'url n'a pas un bon format.
        let url = NSURL(string: urlString)!
        
        // peut echouer si pas internet ou pas de reponse du serveur
        let data = NSData(contentsOfURL: url)!
        
        // Peut echouer si pas un json valide (ie: le serveur retourne une erreur)
        let jsonResponse : AnyObject = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        /* Peut echouer si la structure du json à changer */
        
        let photos = jsonResponse["photos"] as? NSDictionary
        
        
        var result = Array<Photo>()
        
        //TODO : completer le contenu de la boucle for
        // l'objectif est d'obtenir, dans "result", une liste de 250 objet Photo avec chacun une url et un nom (nom par sdefaut = "") 
        // L'exercice est reussi si on arrive a obtenir l'url d'une photo viable (visible en copiant l'url dans safari) (cf result dans l'explorateur d'objet)
        for item in photos!["photo"] as! NSArray
        {
            
            if let photoData = item as? NSDictionary
            {
                let name = photoData["title"] as? String ?? ""
                
                if let farm = photoData["farm"] as? NSNumber,
                let id = photoData["id"] as? String,
                let secret = photoData["secret"] as? String,
                let server = photoData["server"] as? String
                {
                    let photoUrl = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
                    result.append(Photo(url: photoUrl, name: name))
                }
                
            }
            
        }
        
        return result
    }
    
}


