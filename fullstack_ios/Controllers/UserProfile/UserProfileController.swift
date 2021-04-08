//
//  UserProfileController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/8/21.
//

import LBTATools
import Alamofire
import JGProgressHUD

protocol ProfileControllerDelegate: class {
    func toggleFolllowButtonState(isFollowing: Bool)
}

class UserProfileController: LBTAListHeaderController<UserProfileCell, Post, UserProfileHeader> {
    
    // MARK: - Propertise
    let userId: String
    var user: User?
    weak var delegate: ProfileControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
    }
    
    init(userId: String) {
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHeader(_ header: UserProfileHeader) {
        super.setupHeader(header)
        if user == nil { return }
        
        header.user = self.user
        header.userProfileController = self
    }
    
    
    
    // MARK: - Functions
    fileprivate func fetchUserProfile() {
        let url = "\(Service.shared.baseUrl)/user/\(userId)"
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Fetching..."
        hud.show(in: view)
        
        AF.request(url)
            .validate(statusCode: 200..<300)
            .response{ (dataResp) in
                hud.dismiss()
                if let err = dataResp.error {
                    print("Failed to fetch user profile:", err)
                    return
                }
                
                let data = dataResp.data ?? Data()
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.items = user.posts ?? []
                    self.user = user
                    self.collectionView.reloadData()
                } catch {
                    print("Failed to decode user:", error)
                }
            }
    }
    
    func followAndUnfollowTapped() {
        print("you tapped the follow button")
        guard let user = user else {return}
        let isFollowing = user.isFollowing == true
        let url = "\(Service.shared.baseUrl)/\(isFollowing ? "unfollow" : "follow")/\(user.id)"
        AF.request(url, method: .post).validate(statusCode: 200..<300).response {[weak self] (dataResponse) in
            if let error = dataResponse.error {
                print("Failed to follow or unfollow")
                return
            }
            self?.user?.isFollowing = !isFollowing
            self?.collectionView.reloadData()
            self?.delegate?.toggleFolllowButtonState(isFollowing: isFollowing)
        }
    }
}


extension UserProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = estimatedCellHeight(for: indexPath, cellWidth: view.frame.width)
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if user == nil {
            return .zero
        }
        return .init(width: 0, height: 300)
    }
}
