//
//  RootViewController.swift
//  TwtPostLocation
//
//  Created by kkolontay on 10/9/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  
  private let menuWidth: CGFloat = 80.0
  private var menuContainer = UIView(frame: .zero)
  private var postListContainer = UIView(frame: .zero)
  private var menuViewController: MenuViewController?
  private var postListViewController: TwtPostsListViewController?
   private lazy var scrollView: UIScrollView = {
    let scroller = UIScrollView(frame: .zero)
    scroller.isPagingEnabled = true
    scroller.delaysContentTouches = true
    scroller.bounces = false
    scroller.showsHorizontalScrollIndicator = false
    scroller.delegate = self
    return scroller
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
      view.embededInside(scrollView)
      initialMenuContainer()
      initialPostListContainer()
      menuViewController = installFromStorybard("MenuViewController", into: menuContainer) as? MenuViewController
      postListViewController = installFromStorybard("TwtPostsListViewController", into: postListContainer) as? TwtPostsListViewController
    }
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }
  
  private func initialMenuContainer() {
    scrollView.addSubview(menuContainer)
    menuContainer.backgroundColor = .red
    menuContainer.translatesAutoresizingMaskIntoConstraints = false
    menuContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    menuContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    menuContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    menuContainer.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
    menuContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
  }
  
  private func initialPostListContainer() {
    scrollView.addSubview(postListContainer)
    postListContainer.backgroundColor = .green
    postListContainer.translatesAutoresizingMaskIntoConstraints = false
    postListContainer.leadingAnchor.constraint(equalTo: menuContainer.trailingAnchor).isActive = true
    postListContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    postListContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    postListContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    postListContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    postListContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RootViewController: UIScrollViewDelegate {
  
  func installNavigationController(_ rootController: UIViewController) -> UINavigationController {
    let navController = UINavigationController(rootViewController: rootController)
    navController.navigationBar.barTintColor = UIColor(named: "rw-dark")
    navController.navigationBar.tintColor = UIColor(named: "rw-light")
    navController.navigationBar.isTranslucent = true
    navController.navigationBar.clipsToBounds = true
    addChild(navController)
    return navController
  }
  
  func installFromStorybard(_ identifier: String, into container: UIView) -> UIViewController {
    guard let controller = storyboard?.instantiateViewController(identifier: identifier) else {
      fatalError("Storybard missing")
    }
    let nav = installNavigationController(controller)
    container.embededInside(nav.view)
    return controller
  }
  
}
