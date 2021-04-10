//
//  LoginController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit
import JGProgressHUD
import Alamofire

class LoginController: UIViewController {
    // MARK: - Propertise
    var isScrolled:Bool = false
    
    @IBOutlet weak var loginScrolleView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardDisappear), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Functions
    @IBAction func signInButton(_ sender: Any) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Logging..."
        hud.show(in: view)
        self.view.endEditing(true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Service.shared.login(email: email, password: password) { (res) in
            hud.dismiss()
            switch res {
            case .failure:
                print("Failed to log in......")
            case .success:
                self.refreshHomeController()
                self.dismiss(animated: true)
            }
        }
    }
    
    fileprivate func refreshHomeController() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
        mainTabBarController.refreshPost()
    }
    
    
    @IBAction func goToRegisterPage(_ sender: Any) {
        let vc = RegisterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Keyboard Event
    @objc func KeyboardAppear() {
        if !isScrolled {
            self.loginScrolleView.contentSize = CGSize(width: self.view.frame.width, height: self.loginScrolleView.frame.height + 50)
            isScrolled = true
        }
    }
    
    @objc func KeyboardDisappear() {
        if isScrolled {
            self.loginScrolleView.contentSize = CGSize(width: self.view.frame.width, height: self.loginScrolleView.frame.height - 50)
            isScrolled = false
        }
    }
    
}

extension LoginController {
    
}
