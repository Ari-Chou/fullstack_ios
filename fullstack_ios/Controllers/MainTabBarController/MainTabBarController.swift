//
//  MainTabBarController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK: - Propertise
    let homeController = HomeController()
    let userProfileController = UserProfileController(userId: "")
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        self.delegate = self
        setViewControllers([
            generateNavigationController(rootViewController: homeController, title: "Home", image: UIImage(systemName: "house")!, tag: 1),
            generateNavigationController(rootViewController: UIViewController(), title: nil, image: UIImage(systemName: "plus.rectangle.fill")!, tag: 2),
            generateNavigationController(rootViewController: userProfileController, title: "Profile", image: UIImage(systemName: "person.fill")!, tag: 3),
        ], animated: false)
    }
    
    // MARK: - Functions
    func refreshPost() {
        print(".........................")
        homeController.fetchPost()
        userProfileController.fetchUserProfile()
    }
}


extension MainTabBarController {
    fileprivate func generateNavigationController(rootViewController: UIViewController, title: String?, image: UIImage, tag: Int) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            rootViewController.navigationItem.title = title
            navController.tabBarItem.image = image
            return navController
        }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewControllers?.firstIndex(of: viewController) == 1 {
            let vc = CreatePostController()
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}
