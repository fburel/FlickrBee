//
//  UrlDataCache.swift
//  FlickrBee
//
//  Created by florian BUREL on 25/09/2015.
//  Copyright (c) 2015 florian BUREL. All rights reserved.
//

import Foundation

class UrlDataCache {
    
    private var cachedData = [NSURL : NSData]()
    
    private var downloadingUrls = Set<NSURL>()
    
    func hasDataCachedForUrl(url:NSURL) -> Bool
    {
        return (cachedData[url] != nil)
    }
    
    func dataForUrl(url:NSURL) -> NSData?
    {
        return cachedData[url]
    }
    
    func fetchDataForUrl(url:NSURL, completion:(NSData?)->Void)
    {
        let qos = DISPATCH_QUEUE_PRIORITY_HIGH
        let global_queue = dispatch_get_global_queue(qos, 0)
        
        if !self.downloadingUrls.contains(url)
        {
            self.downloadingUrls.insert(url)
            
            dispatch_async(global_queue){
                
                let d = NSData(contentsOfURL: url)
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    self.downloadingUrls.remove(url)
                    
                    if let data = d
                    {
                        self.cachedData[url] = data
                    }
                    
                    completion(d)
                    
                    
                }
            }
        }
        else
        {
            completion(nil)
        }
    }
}