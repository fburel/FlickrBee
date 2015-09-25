//
//  MapViewController.swift
//  FlickrBee
//
//  Created by florian BUREL on 25/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var completionHandler : ((CLLocationCoordinate2D?)->Void)?

    @IBAction func cancel(sender: UIBarButtonItem) {
        if let handler = completionHandler
        {
            handler(nil)
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        let coordinate = self.mapView.centerCoordinate
        if let handler = completionHandler
        {
            handler(coordinate)
        }
    }
}
