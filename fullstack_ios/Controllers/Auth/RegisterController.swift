//
//  RegisterController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit
import JGProgressHUD
import Alamofire

class RegisterController: UIViewController {
    // MARK: - Propertise
    fileprivate var isScrolled = false
    @IBOutlet weak var registerScrollView: UIScrollView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registring..."
        hud.show(in: view)
        self.view.endEditing(true)
        guard let fullName = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Service.shared.signUp(fullName: fullName, emailAddress: email, password: password) { (res) in
            
            hud.dismiss(animated: true)
            
            switch res {
            case .failure(let err):
                print("Failed to sign up:", err)
                self.errorMessageLabel.isHidden = false
            case .success:
                print("Successfully signed up")
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func toLoginPageButton(_ sender: Any) {
        let vc = LoginController()
        navigationController?.pushViewController(vc, animated: true)
    }
    // Keyboard Event
    @objc func KeyboardAppear() {
        if !isScrolled {
            self.registerScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.registerScrollView.frame.height + 50)
            isScrolled = true
        }
    }
    
    @objc func KeyboardDisappear() {
        if isScrolled {
            self.registerScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.registerScrollView.frame.height - 50)
            isScrolled = false
        }
    }

}
