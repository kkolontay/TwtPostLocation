//
//  ImageCache.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class ImageCache {
   static  let shared = ImageCache()
  var imageCache: NSCache<AnyObject, AnyObject>?
  private init() {
    imageCache = NSCache<AnyObject, AnyObject>()
  }
}

