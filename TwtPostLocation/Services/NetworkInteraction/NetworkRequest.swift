//
//  NetworkRequest.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation
import SystemConfiguration


let CONNECTIONPRESENTS = "connectionAppear";
let CONNECTIONLOST = "connectionDisappear";

enum HttpMethod : String {
  case get
  func toString() -> String {
    return "GET"
  }
}

enum StringURLRequest: String {
  
  case host = "https://api.md-fashion.com.ua/v1/"
  
  static func checkoutUser() -> String {
    return StringURLRequest.host.rawValue + "checkout-validation/user"
  }
}

class NetworkRequests: AsyncOperation {
  
 private var handler: ((Data?, String?) -> Void)?
private var url: String?
 private var httpMethod: String?
 private var httpBody: Data?
  
  init(_ url: String, httpMethod: HttpMethod = .get, handler: @escaping (Data?, String?) -> Void) {
    super.init()
    self.handler = handler
    self.url = url
    self.httpMethod = httpMethod.toString()
  }
  
  
  override func main() {
    if isInternetAvailable() {
      NotificationCenter.default.post(name: NSNotification.Name(CONNECTIONPRESENTS), object: nil)
    } else {
      NotificationCenter.default.post(name: NSNotification.Name(CONNECTIONLOST), object: nil)
      self.state = .Finished
      return
    }
    if let url = url, let request = createURLRequest(url, httpMethod: httpMethod ?? "GET") {
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        if self?.isCancelled  ?? false {
          self?.state = .Finished
          return
        }
        if error != nil {
          if (self?.isFinished ?? false) {return}
          self?.handler?(nil, error?.localizedDescription)
          self?.state = .Finished
          return
        }
        if let responseCode = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= responseCode, let data = data {
            self?.handler?(data, nil)
            self?.state = .Finished
            
          } else {
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
              let errorMessage = String(format: NSLocalizedString("errorConnection", comment: ""), responseCode)
              self?.handler?(nil, errorMessage)
            }
            self?.state = .Finished
          }
        }
      }.resume()
    }
  }
  
  
 private func createURLRequest(_ url: String, httpMethod: String) -> URLRequest? {
    guard let url = URL(string: url) else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = UserDefaults.standard.string(forKey: "token"), !token.isEmpty {
      
      request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    if (httpMethod == "POST" || httpMethod == "PATCH" || httpMethod == "PUT") && httpBody != nil {
      request.httpBody = httpBody
    }
    return request
  }
  
 private func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
  }
}
