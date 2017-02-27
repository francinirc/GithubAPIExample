//
//  User.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 26/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import Foundation

class User {
    
    var login: String?
    var id: Int?
    var avatarUrl: String?
    var repositoriesUrl: String?
    
    init(login: String, id: Int, avatarUrl: String, repositoriesUrl: String) {
        self.login = login
        self.id = id
        self.avatarUrl = avatarUrl
        self.repositoriesUrl = repositoriesUrl
    }
}
