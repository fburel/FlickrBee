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
    
    private var cache = [Int:NSData]()
    
    private var global_queue : dispatch_queue_t!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var qos = DISPATCH_QUEUE_PRIORITY_HIGH
        global_queue = dispatch_get_global_queue(qos, 0)

        let downloader = FlickrDownloader()
        
        self.collectionView.dataSource = self
                
        dispatch_async(global_queue) {
            
            let p = downloader.photosForLocation(downloader.Budapest)
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.photos = p
                
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        self.cache = [Int:NSData]()
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotosViewController.CELL_IDENTIFIER, forIndexPath: indexPath) as! UICollectionViewCell
        
        // Configure la cell
        
        var imageView = cell.viewWithTag(1)! as! UIImageView
        
        if let data = self.cache[indexPath.item]
        {
            let emile = UIImage(data: data)
            
            imageView.image = emile
        }
        else
        {
            let photo = self.photos[indexPath.item]
            
            imageView.image = UIImage(named: "loading")
            
            dispatch_async(global_queue){
                
                let data = NSData(contentsOfURL: photo.url)!
                
                dispatch_async(dispatch_get_main_queue()){

                    
                    self.cache[indexPath.item] = data
                    
                    self.collectionView.reloadItemsAtIndexPaths([indexPath])

                    
                }
            }
            
        }

        return cell
        
    }
    
}
