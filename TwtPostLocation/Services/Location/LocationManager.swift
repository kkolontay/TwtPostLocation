//
//  LocationManager.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {
  private var mainLocationManager: CLLocationManager?
  private var currentLocation: CurrentLocationPresenter?
  
  override init() {
    super.init()
   authorizationChecker()
  }
  
  private func authorizationChecker() {
    switch CLLocationManager.authorizationStatus() {
       case .notDetermined, .restricted, .denied:
           mainLocationManager = CLLocationManager()
           mainLocationManager?.delegate = self
           mainLocationManager?.requestAlwaysAuthorization()
       case .authorizedWhenInUse, .authorizedAlways:
           mainLocationManager = CLLocationManager()
           mainLocationManager?.delegate = self
        default:
         break
       }
  }
}

extension LocationManager: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    currentLocation = CurrentLocationPresenter(location: location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways || status == .authorizedWhenInUse {
      mainLocationManager?.requestLocation()
      mainLocationManager?.startMonitoringVisits()
    } else if status == .denied || status == .restricted || status == .notDetermined {
      print( "Location not used, you can used this application, you need give permission using localizaton")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print( error.localizedDescription)
  }
}
