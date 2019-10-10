//
//  ImageDowloader.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class ImageDownloader: AsyncOperation {
  
  private var request: URLRequest?
  private var handler: ((UIImage?, String?) -> Void)?
  // private var handlerUrl: ((UIImage?, String?, String?) -> Void)?
  private let  query = DispatchQueue(label: "finisedqueue")
  
  init?(_ url: String, handler: @escaping (UIImage?, String?) -> (Void)) {
    super.init()
    self.handler = handler
    guard let url = URL(string: url) else {
      return nil
    }
    request = URLRequest(url: url)
    request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request?.httpMethod = "GET"
  }
  
  
  //  init(_ url: String, handlerUrl: @escaping (UIImage?, String?, String?) -> (Void)) {
  //    super.init()
  //    self.handlerUrl = handlerUrl
  //    guard let urlCheck = URL(string: url) else {
  //      handlerUrl(nil, "URL isn't correct", url)
  //      return
  //    }
  //    request = URLRequest(url: urlCheck)
  //    request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
  //    request?.httpMethod = "GET"
  //  }
  
  
  override func main() {
    
    guard let request = self.request else {
      query.sync() { [weak self] in
        self?.state = .Finished
      }
      return
    }
    if let image = ImageCache.shared.imageCache?.object(forKey: request.url?.absoluteString as AnyObject) as? UIImage {
      if self.isCancelled {
        self.query.sync {
          self.state = .Finished
        }
        return
      }
      self.handler?(image, nil )
      query.sync {
        self.state = .Finished
      }
      return
    } else {
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        if self?.isCancelled  ?? false {
          self?.query.sync { [weak self] in
            self?.state = .Finished
          }
          return
        }
        if error != nil {
          self?.handler?(nil, error?.localizedDescription)
          self?.query.sync { [weak self] in
            self?.state = .Finished
          }
          return
        }
        if let response = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= response, let data = data {
            if  let image = UIImage(data: data) {
              ImageCache.shared.imageCache?.setObject(image, forKey: request.url?.absoluteString as AnyObject)
              if self?.isCancelled  ?? false {
                self?.query.sync { [weak self] in
                  self?.state = .Finished
                }
                return
              }
              self?.handler?(image, nil)
              self?.query.sync { [weak self] in
                self?.state = .Finished
              }
            }
          }
        } else {
          let statusCode = (response as? HTTPURLResponse)?.statusCode
          if (self?.isFinished ?? false) {return}
           let errorMessage = String(format: NSLocalizedString("errorConnection", comment: ""), statusCode ?? 0)
          self?.handler?(nil, errorMessage)
          self?.query.sync { [weak self] in
            self?.state = .Finished
          }
        }
      }.resume()
    }
  }
}
