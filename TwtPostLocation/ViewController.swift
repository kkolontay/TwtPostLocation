//
//  ViewController.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private var locationManager: LocationManager?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    locationManager = LocationManager()
  }


}

