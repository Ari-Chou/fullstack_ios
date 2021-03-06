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
        setupNavItem()
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
     func fetchUserProfile() {
        let currentUserProfileUrl = "\(Service.shared.baseUrl)/profile"
        let publicUserProfileUrl = "\(Service.shared.baseUrl)/user/\(userId)"
        
        let url = self.userId.isEmpty ? currentUserProfileUrl : publicUserProfileUrl
        
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
                    self.user?.profileButtonIsEditable = self.userId.isEmpty 
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
    
    // Setup navigationItem base on the
    fileprivate func setupNavItem() {
        if userId.isEmpty {
            navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(handleSetting))
        }
    }
    
    @objc fileprivate func handleSetting() {
        let alertController = UIAlertController(title: "LogOut", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("Log out")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
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

extension UserProfileController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func changeUserProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            self.uploadUserProfileImage(image: originalImage)
        } else if let editedImage = info[.editedImage] as? UIImage {
            self.uploadUserProfileImage(image: editedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadUserProfileImage(image: UIImage) {
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Uploading..."
        hud.show(in: view)
        // upload user profile image
        let url = "\(Service.shared.baseUrl)/profile"
       
        guard let user = self.user else { return }
        
        AF.upload(multipartFormData: { (formData) in
            // Post Text
            formData.append(Data(user.fullName.utf8), withName: "fullName")
            let bioData = Data((user.bio ?? "").utf8)
            formData.append(bioData, withName: "bio")
            
            // Post Image
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imageFile", fileName: "Doesn'tMatterSoMuch", mimeType: "image/jpg")
        }, to: url,
        method: .post,
        headers: nil)
        .responseJSON(completionHandler: { data in
        }).response { (dataResp) in
            
            if let error = dataResp.error {
                print("Failed to hit server", error.localizedDescription)
                return
            }
            if let code = dataResp.response?.statusCode, code >= 300 {
                print("Failed upload with", code)
                return
            }
            hud.dismiss()
            print("Scussfully uploated user profile")
            self.fetchUserProfile()
        }
    }
}
