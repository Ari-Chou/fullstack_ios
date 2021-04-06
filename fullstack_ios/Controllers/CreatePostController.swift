//
//  CreatePostController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class CreatePostController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
