//
//  ViewController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class HomeController: UITableViewController {
    
    // MARK: - Propertise
    fileprivate let cellID = "cell"
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(title: "SignIn", style: .plain, target: self, action: #selector(handleLogin))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        showCookie()
        fetchPost()
    }
    
    // MARK: - Functions
    @objc func handleLogin() {
        let nav = UINavigationController(rootViewController: LoginController())
        
        present(nav, animated: true, completion: nil)
    }
    
    fileprivate func showCookie() {
        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            print(cookie)
        })
    }
    
    func fetchPost() {
        Service.shared.fetchPosts { (res) in
            switch res {
            case .failure(let err):
                print("Failed to fetch posts:", err)
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
}


extension HomeController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
