//
//  CommentController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/10/21.
//

import UIKit
import Alamofire
import LBTATools
import SDWebImage

class CommentController: UITableViewController {
    
    // MARK: - Propertise
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.startAnimating()
        indicator.color = .darkGray
        return indicator
    }()
    var postId: String
    var comments = [Comment]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadIndicator()
        fetchPostComments()
    }
    
    init(postId: String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    fileprivate func fetchPostComments() {
        let url = "\(Service.shared.baseUrl)/post/\(postId)"
        AF.request(url).responseData { (dataresponsed) in
            self.indicatorView.stopAnimating()
            guard let data = dataresponsed.data else { return}
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                self.comments = post.comments ?? []
                self.tableView.reloadData()
            } catch {
                print("Failed to decode the post", error.localizedDescription)
            }
        }
    }
    
    fileprivate func setupLoadIndicator() {
        tableView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
}

extension CommentController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
        let comment = comments[indexPath.row]
        cell.commentTextLabel.text = comment.text
        cell.profileImageView.sd_setImage(with: URL(string: comment.user.profileImageUrl ?? ""), completed: nil)
        cell.timeLabel.text = comment.fromNow
        cell.username.text = comment.user.fullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
