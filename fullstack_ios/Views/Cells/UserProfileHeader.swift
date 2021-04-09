//
//  UserProfileHeader.swift
//  fullstack_ios
//
//  Created by AriChou on 4/8/21.
//

import LBTATools

class UserProfileHeader: UICollectionReusableView {
    
    // MARK: - Propertise
    let profileImageView = CircularImageView(width: 80)
    
    let followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 13), target: self, action: #selector(handleFollow))
    
    // this button will show when the profile page is belong the current login user.
    let editProfileButton = UIButton(title: "Edit Profile", titleColor: .white, font: .boldSystemFont(ofSize: 13), backgroundColor: .black, target: self, action: #selector(handleEditProfile))
    
    let postsCountLabel = UILabel(text: "12", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let postsLabel = UILabel(text: "posts", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followersCountLabel = UILabel(text: "500", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let followersLabel = UILabel(text: "followers", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let followingCountLabel = UILabel(text: "500", font: .boldSystemFont(ofSize: 14), textAlignment: .center)
    let followingLabel = UILabel(text: "following", font: .systemFont(ofSize: 13), textColor: .lightGray, textAlignment: .center)
    
    let fullNameLabel = UILabel(text: "Username", font: .boldSystemFont(ofSize: 14))
    let bioLabel = UILabel(text: "Here's an interesting piece of bio that will definitely capture your attention and all the fans around the world.", font: .systemFont(ofSize: 13), textColor: .darkGray, numberOfLines: 0)
    
    weak var userProfileController: UserProfileController?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    @objc func handleFollow() {
        userProfileController?.followAndUnfollowTapped()
    }
    
    @objc func handleEditProfile() {
        
    }
    
    var user: User! {
        didSet {
            profileImageView.image = UIImage(systemName: "person.circle")
            fullNameLabel.text = user?.fullName
            followButton.setTitle(user.isFollowing == true ? "Unfollow" : "Follow", for: .normal)
            followButton.backgroundColor = user.isFollowing == true ? .black : .white
            followButton.setTitleColor(user.isFollowing == true ? .white : .black, for: .normal)
            
            if user.profileButtonIsEditable == true {
                followButton.removeFromSuperview()
            } else {
                editProfileButton.removeFromSuperview()
            }
            
            postsCountLabel.text = "\(user.posts?.count ?? 0)"
            followersCountLabel.text = "\(user.followers?.count ?? 0)"
            followingCountLabel.text = "\(user.following?.count ?? 0)"
        }
    }
    
    
    fileprivate func layoutElement() {
        profileImageView.isUserInteractionEnabled = true
        
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 1
        editProfileButton.layer.cornerRadius = 15
        editProfileButton.layer.borderWidth = 1
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderWidth = 1
        profileImageView.tintColor = .black
        
        stack(
            profileImageView,
            followButton.withSize(.init(width: 100, height: 28)),
            editProfileButton.withSize(.init(width: 100, height: 28)),
            hstack(stack(postsCountLabel, postsLabel),
                   stack(followersCountLabel, followersLabel),
                   stack(followingCountLabel, followingLabel),
                   spacing: 16, alignment: .center),
            fullNameLabel,
            bioLabel,
            spacing: 12,
            alignment: .center
        ).withMargins(.allSides(14))
        
        let separatorView = UIView(backgroundColor: .init(white: 0.4, alpha: 0.3))
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
}
