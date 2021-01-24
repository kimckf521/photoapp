//
//  ImageCacheService.swift
//  Photoapp
//
//  Created by Kim on 24/9/20.
//  Copyright © 2020 Kim. All rights reserved.
//

import Foundation
import UIKit

class ImageCacheService {
    
    static var imageCache = [String:UIImage]()
    
    static func saveImage(url:String?, image:UIImage?) {
        
        // Check against  nil
        if url == nil || image == nil {
            return
        }
        // save image
        imageCache[url!] = image!
        
    }
    
    static func getImage(url:String?) -> UIImage? {
        
        // Check that url is not nil
        if url == nil {
            return nil
        }
        
        // Check the image cache for the url
        return imageCache[url!]
    }
}
