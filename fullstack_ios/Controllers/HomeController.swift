//
//  ViewController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit
import SDWebImage
import Alamofire

class HomeController: UITableViewController {
    
    // MARK: - Propertise
    fileprivate let cellID = "cell"
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [.init(title: "SignIn", style: .plain, target: self, action: #selector(handleLogin)), .init(title: "Search", style: .plain, target: self, action: #selector(handleSearch))]
        showCookie()
        fetchPost()
    }
    
    // MARK: - Functions
    @objc func handleLogin() {
        let nav = UINavigationController(rootViewController: LoginController())
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSearch() {
        let nv = UINavigationController(rootViewController: UsersSearchController())
        present(nv, animated: true, completion: nil)
        
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
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.delegate = self
        cell.usernameLabel.text = post.user.fullName
        cell.userPostTextLabel.text = post.text
        cell.userPostImageView.sd_setImage(with: URL(string: post.imageUrl), completed: nil)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 547
    }
}

// MARK: - Delete post
extension HomeController: PostCellOptionDelegate {
    func handlePostOption(cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = self.posts[indexPath.row]
        let url = "\(Service.shared.baseUrl)/post/\(post.id)"
        
        let alertController = UIAlertController(title: "Delete Post?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            AF.request(url, method: .delete)
                .validate(statusCode: 200..<300)
                .response {[weak self] (dataResponse) in
                    if let error = dataResponse.error {
                        print("Failed to hit the server", error.localizedDescription)
                        return
                    }
                    self?.posts.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
