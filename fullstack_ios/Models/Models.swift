//
//  Models.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import Foundation

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let imageUrl: String
    let user: User
}

struct User: Decodable {
    let id: String
    let fullName: String
    var isFollowing: Bool?
    
    var posts: [Post]?
    var following: [User]?
    var followers: [User]?
    var profileButtonIsEditable: Bool?
    var bio: String?
    var profileImageUrl: String?
}
