//  
//  MenuViewModel.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

class MenuViewModel {

  private let service: MenuServiceProtocol

  private var model: [MenuModel] = [MenuModel]()

  // update loading status
  var isLoading: Bool = false {
      didSet {
          self.updateLoadingStatus?()
      }
  }

  // show alert message
  var alertMessage: String? {
      didSet {
          self.showAlertClosure?()
      }
  }

  // selected model
  var selectedObject: MenuModel?

  // closure callback
  var showAlertClosure: (() -> ())?
  var updateLoadingStatus: (() -> ())?

  init(withMenu serviceProtocol: MenuServiceProtocol = MenuService() ) {
    self.service = serviceProtocol
  }

}

extension MenuViewModel {

}