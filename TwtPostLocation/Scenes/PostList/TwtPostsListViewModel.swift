//  
//  TwtPostsListViewModel.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

class TwtPostsListViewModel {

  private let service: TwtPostsListServiceProtocol

  private var model: [TwtPostsListModel] = [TwtPostsListModel]()

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
  var selectedObject: TwtPostsListModel?

  // closure callback
  var showAlertClosure: (() -> ())?
  var updateLoadingStatus: (() -> ())?

  init(withTwtPostsList serviceProtocol: TwtPostsListServiceProtocol = TwtPostsListService() ) {
    self.service = serviceProtocol
  }

}

extension TwtPostsListViewModel {

}