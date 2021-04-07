//
//  CreatePostController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit
import JGProgressHUD
import Alamofire

class CreatePostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    // MARK: - Propertise
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    var selectedImage: UIImage?
    weak var homeController: HomeController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewAction()
        initTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Functions
    
    @IBAction func postButton(_ sender: Any) {
        let url = "http://localhost:1337/post"
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        guard let text = postTextView.text else { return }
        
        AF.upload(multipartFormData: { (formData) in
            // Post Text
            formData.append(Data(text.utf8), withName: "postBody")
            
            // Post Image
            guard let imageData = self.selectImageView.image!.jpegData(compressionQuality: 0.5) else { return }
            formData.append(imageData, withName: "imagefile", fileName: "Doesn'tMatterSoMuch", mimeType: "image/jpg")
        }, to: url,
        method: .post,
        headers: nil) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            DispatchQueue.main.async {
                hud.progress = Float(progress.fractionCompleted)
                hud.textLabel.text = "Uploading\n\(Int(progress.fractionCompleted * 100))% Complete"
            }
        }).responseJSON(completionHandler: { data in
        }).response { (dataResp) in
            switch dataResp.result {
            case .success(let result):
                hud.dismiss()
        
                if let err = dataResp.error {
                    print("Failed to hit server:", err)
                    return
                }
                
                if let code = dataResp.response?.statusCode, code >= 300 {
                    print("Failed to upload with status: ", code)
                    return
                }
                
                print("Successfully created post, here is the response:")
                
                self.dismiss(animated: true) {
                    self.homeController?.fetchPost()
                }
            case .failure(let err):
                print("upload err: \(err)")
            }
            self.view.endEditing(true)
        }
    }
    
    func imageViewAction() {
        selectImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleImageSelect(sender:)))
        selectImageView.addGestureRecognizer(gesture)
    }
    
    @objc func handleImageSelect(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func initTextView() {
        postTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
    }
}

extension CreatePostController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            selectImageView.image = originalImage
        } else if let editedImage = info[.editedImage] as? UIImage {
            selectImageView.image = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
}


