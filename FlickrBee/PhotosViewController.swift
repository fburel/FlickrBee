//
//  PhotosViewController.swift
//  FlickrBee
//
//  Created by florian BUREL on 24/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDataSource {

    static let CELL_IDENTIFIER = "PHOTO_CELL"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photos = Array<Photo>()
    
    private let cache = UrlDataCache()
    
    private let downloader = FlickrDownloader()
    
    var locationToDisplay:FlickrLocation?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.collectionView.dataSource = self
        
        if let pos = locationToDisplay
        {
            self.downloader.fetchPhotosForLocation(pos) { (photos) in
                self.photos = photos
                self.collectionView.reloadData()
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        // TODO : ajouter une méthode a UrlDataCache pour vider le cache
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotosViewController.CELL_IDENTIFIER, forIndexPath: indexPath) 
        
        // Configure la cell
        
        let imageView = cell.viewWithTag(1)! as! UIImageView
        
        let photo = self.photos[indexPath.item]
        
        if let data = self.cache.dataForUrl(photo.url)
        {
            imageView.image = UIImage(data: data)
        }
        else
        {

            imageView.image = UIImage(named: "loading")
            
            self.cache.fetchDataForUrl(photo.url){ (data) in
                if data != nil
                {
                    self.collectionView.reloadItemsAtIndexPaths([indexPath])

                }
            }
        }

        return cell
        
    }
    
}
