//
//  UserSearchControllerViewController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/8/21.
//

import UIKit
import LBTATools
import Alamofire

class UsersSearchController: LBTAListController<UserSearchCell, User> {
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        Service.shared.searchForUsers { (res) in
            switch res {
            case .failure(let err):
                print("Failed to find users:", err)
            case .success(let users):
                self.items = users
                self.collectionView.reloadData()
            }
        }
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout, ProfileControllerDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = self.items[indexPath.row]
        selectedUser = user
        let vc = UserProfileController(userId: user.id)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toggleFolllowButtonState(isFollowing: Bool) {
        guard let index = self.items.firstIndex(where: {$0.id == selectedUser?.id}) else { return }
        self.items[index].isFollowing = !isFollowing
        print("at same time you tapped search controller button")
    }
}


extension UsersSearchController {
    func didFollow(user: User) {
        guard let index = self.items.firstIndex(where: {$0.id == user.id}) else { return }
        
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to unfollow:", err)
                }
                self.items[index].isFollowing = !isFollowing
                self.collectionView.reloadData()
                
        }
        
    }
}



