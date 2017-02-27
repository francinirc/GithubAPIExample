//
//  GithubAPI.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 26/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import Foundation
import Alamofire

class GithubAPI {
 
    static let githubRetrivePopularUsers = "https://api.github.com/search/users?q=repos:%3E100+followers:%3E1000"
    
    
    static func getUsersList() -> [User] {
        var users = [User]()
        
        
        Alamofire.request(githubRetrivePopularUsers).responseJSON {
            response in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                return
            
            }
        
        
            print(response.request!)  // original URL request
//            print(response.response!) // URL response
//            print(response.data!)     // server data
            print(response.result)   // result of response serialization
            
        
            let json = response.result.value as? [String: Any]
            let total = json?["total_count"] as? [[Int: AnyObject]]
            
            print(total)
            //print(json)
            
            guard let items = json?["items"] as? [[String: AnyObject]] else {
                return
            }
            
            
            for item in items {
                guard let login = item["login"] as? String,
                let avatar = item["avatar_url"] as? String,
                    let repos = item["repos_url"] as? String else { break }
                
                print(login)
                print(avatar)
                print(repos)
                
                users.append(User(login: login, id: 0, avatarUrl: avatar, repositoriesUrl: repos))
            }
            
            print(users.count)
        
        }
        
        return users
    }
}
