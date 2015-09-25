//
//  City.swift
//  FlickrBee
//
//  Created by florian BUREL on 25/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import Foundation
import CoreData

class City: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber

}
