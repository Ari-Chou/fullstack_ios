//
//  HomeTableViewCell.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    // MARK: - Propertise
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userPostImageView: UIImageView!
    @IBOutlet weak var userPostTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func moreButton(_ sender: Any) {
        print("Apple")
    }
    @IBAction func likeButton(_ sender: Any) {
    }
    
    @IBAction func messageButton(_ sender: Any) {
    }
    @IBAction func sendButton(_ sender: Any) {
    }
    @IBAction func bookmarkButton(_ sender: Any) {
    }
}
