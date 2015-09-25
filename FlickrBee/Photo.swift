//
//  Photo.swift
//  FlickrBee
//
//  Created by florian BUREL on 24/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import Foundation

class Photo {
    
    let url : NSURL
    let name : String
    
    init(url:String, name:String)
    {
        if let constructedUrl = NSURL(string: url)
        {
            self.url = constructedUrl
        }
        else
        {
            self.url = NSURL(string: "http://en.gravatar.com/userimage/73026054/80be44101ca6742821b282400fbde205.png")!
        }
        self.name = name
    }
    
}