//
//  MainTabBarController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Propertise
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        setViewControllers([
         generateNavigationController(rootViewController: HomeController(), title: "Home", image: UIImage(systemName: "house")!, tag: 1),
            generateNavigationController(rootViewController: ProfileController(), title: "Profile", image: UIImage(systemName: "person.fill")!, tag: 2),
        ], animated: false)
    }
}


extension MainTabBarController {
    fileprivate func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage, tag: Int) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            rootViewController.navigationItem.title = title
            navController.tabBarItem.image = image
            return navController
        }
}
