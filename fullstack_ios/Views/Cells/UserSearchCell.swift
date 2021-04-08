//
//  UserSearchCell.swift
//  fullstack_ios
//
//  Created by AriChou on 4/8/21.
//

import LBTATools
import Alamofire




class UserSearchCell: LBTAListCell<User> {
    
    let nameLabel = UILabel(text: "Full Name", font: .boldSystemFont(ofSize: 16), textColor: .black)
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    
    
    @objc fileprivate func handleFollow() {
        (parentController as? UsersSearchController)?.didFollow(user: item)
    }
    
    override func setupViews() {
        super.setupViews()
        followButton.layer.cornerRadius = 5
        followButton.layer.borderWidth = 1
        
        hstack(nameLabel, UIView(), followButton.withWidth(100).withHeight(34), alignment: .center).padLeft(24).padRight(24)
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
    
    override var item: User! {
        didSet {
            nameLabel.text = item.fullName
            if item.isFollowing == true {
                followButton.backgroundColor = .black
                followButton.setTitleColor(.white, for: .normal)
                followButton.setTitle("Unfollow", for: .normal)
            } else {
                followButton.backgroundColor = .white
                followButton.setTitleColor(.black, for: .normal)
                followButton.setTitle("Follow", for: .normal)
            }
        }
    }
}
