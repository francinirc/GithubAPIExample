//
//  Repository.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 27/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import Foundation

class Repository {
    
    var name: String?
    var description: String?
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}
