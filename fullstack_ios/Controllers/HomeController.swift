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
        navigationItem.leftBarButtonItem = .init(title: "SignIn", style: .plain, target: self, action: #selector(handleLogin))
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleSearch))
        showCookie()
        fetchPost()
        setupRefreshController()
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
    
    @objc func fetchPost() {
        Service.shared.fetchPosts { (res) in
            self.tableView.refreshControl?.endRefreshing()
            switch res {
            case .failure(let err):
                print("Failed to fetch posts:", err)
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }
    
    func setupRefreshController() {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchPost), for: .valueChanged)
        self.tableView.refreshControl = rc
    }
}


extension HomeController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        let post = posts[indexPath.row]
        cell.cellOptionButtonDelegate = self
        cell.cellCommentButtonDelegate = self
        cell.usernameLabel.text = post.user.fullName
        cell.userPostTextLabel.text = post.text
        cell.postTimeLabel.text = post.fromNow
        cell.userPostImageView.sd_setImage(with: URL(string: post.imageUrl), completed: nil)
        cell.userAvatarImageView.sd_setImage(with: URL(string: post.user.profileImageUrl ?? ""), completed: nil)
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

// MARK: - Comment post
extension HomeController: PostCellCommentDelegate {
    func handleCommentButton(cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = self.posts[indexPath.row]
        let vc = CommentController(postId: post.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
