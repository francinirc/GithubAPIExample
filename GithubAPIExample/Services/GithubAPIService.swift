//
//  GithubAPI.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 26/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import Foundation
import Alamofire

class GithubAPIService {
 
    static let githubRetrivePopularUsers = "https://api.github.com/search/users?q=repos:%3E100+followers:%3E1000"
    
   
    static func loadUsersInformation(completion: @escaping ([User]) -> Void) {
        var usersList = [User]()
        
        Alamofire.request(GithubAPIService.githubRetrivePopularUsers).responseJSON(completionHandler: {
            response in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                
                return
            }
            
            self.parseData(JSONData: response.data!, usersList: &usersList)
            print("usuarios: ", usersList.count)
        })
        
        DispatchQueue.main.async {
            print(usersList.count)
            completion(usersList)
        }
        
        
    }

    
    static func parseData(JSONData: Data, usersList: inout [User]) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
            
            if let items = readableJSON["items"] as? [[String: Any]] {
                
                for item in items {
                    
                    guard let login = item["login"] as? String,
                        let id = item["id"] as? Int,
                        let avatarUrl = item["avatar_url"] as? String,
                        let reposUrl = item["repos_url"] as? String else { break }

                    
                    let user = User(login: login, id: id, avatarUrl: avatarUrl, repositoriesUrl: reposUrl)
                    usersList.append(user)
                }
            }
        }
        catch {
            print(error)
        }
        
    }
    
}
