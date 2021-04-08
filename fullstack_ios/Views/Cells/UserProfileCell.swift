//
//  UserProfileCell.swift
//  fullstack_ios
//
//  Created by AriChou on 4/8/21.
//

import LBTATools

class UserProfileCell: LBTAListCell<Post> {
    
    // MARK: - Propertise
    let usernameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 15))
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "Post text spanning multiple lines", font: .systemFont(ofSize: 15), numberOfLines: 0)
    lazy var optionsButton = UIButton(image: UIImage(systemName: "ellipsis")! , tintColor: .black, target: self, action: #selector(handleOptions))
    var imageHeightAnchor: NSLayoutConstraint!
    
    // MARK: - Functions
    @objc func handleOptions() {
        
    }
    
    // MARK: -
    override var item: Post! {
        didSet {
            usernameLabel.text = item.user.fullName
            postImageView.sd_setImage(with: URL(string: item.imageUrl))
            postTextLabel.text = item.text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageHeightAnchor.constant = frame.width
    }
    
    override func setupViews() {
        super.setupViews()
        imageHeightAnchor = postImageView.heightAnchor.constraint(equalToConstant: 0)
        imageHeightAnchor.isActive = true
        
        stack(hstack(usernameLabel,
                     UIView(),
                     optionsButton.withWidth(34)).padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
    }
}
