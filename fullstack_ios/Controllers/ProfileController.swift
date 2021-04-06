//
//  ProfileController.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import UIKit

class ProfileController: UITableViewController {
    // MARK: - Propertise
    fileprivate let cellID = "cell"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
