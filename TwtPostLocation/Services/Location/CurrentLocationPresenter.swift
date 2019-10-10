//
//  CurrentLocationPresenter.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import CoreLocation

let currentLocationKey = "currentLocationKye";

class CurrentLocationPresenter {
  
  var currentLocaton: CLLocation {
    guard let dataCurrentLocaton = UserDefaults.standard.data(forKey: currentLocationKey) else {
      return CLLocation(latitude: 43.891200152, longitude: -79.42205801)
    }
    let decoder = JSONDecoder()
    do {
      let currentLocation = try decoder.decode(LocationCoordinat.self, from: dataCurrentLocaton)
      return CLLocation(latitude: currentLocation.latitude ?? 43.89, longitude: currentLocation.longitude ?? -79.42)
      
    } catch {
      return CLLocation(latitude: 43.891200152, longitude: -79.42205801)
    }
  }
  
  init() {}
  
  init(location: CLLocation) {
    storeCurrentLocation(location: location)
  }
  
  private func storeCurrentLocation(location: CLLocation) {
    let currentLocation = LocationCoordinat(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let encode = JSONEncoder()
    do {
      let data = try encode.encode(currentLocation)
      UserDefaults.standard.set(data, forKey: currentLocationKey)
      
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
}
