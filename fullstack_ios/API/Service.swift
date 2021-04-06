//
//  Service.swift
//  fullstack_ios
//
//  Created by AriChou on 4/6/21.
//

import Foundation
import Alamofire

class Service: NSObject {
    static let shared = Service()
    let baseUrl = "http://localhost:1337"
    
    func login(email: String, password: String, completion: @escaping (Result<Data, Error>) -> ()) {
        let params = ["emailAddress": email, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/login"
        AF.request(url, method: .put, parameters: params).validate(statusCode: 200..<300).responseData { (dataResponse) in
            if let error = dataResponse.error {
                completion(.failure(error))
            } else {
                completion(.success(dataResponse.data ?? Data()))
            }
        }
    }
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        let url = "\(baseUrl)/post"
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                guard let data = dataResp.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    func signUp(fullName: String, emailAddress: String, password: String, completion: @escaping (Result<Data, Error>) -> ()) {
        let params = ["fullName": fullName, "emailAddress": emailAddress, "password": password]
        let url = "\(baseUrl)/api/v1/entrance/signup"
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                completion(.success(dataResp.data ?? Data()))
        }
    }
}
