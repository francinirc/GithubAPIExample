//
//  RepositoriesTableViewController.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 27/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import UIKit
import Alamofire

class RepositoriesTableViewController: UITableViewController {

    var user: User?
    var repoList = [Repository]()
    var filteredResults = [Repository]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()

        if user != nil {
            self.navigationItem.title = "Repositórios de \(user!.login!)"
            
            loadRepositoriesInformation()
        }
        
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResults.count
        }
        
        return repoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath)

        if searchController.isActive && searchController.searchBar.text != "" {
            cell.textLabel?.text = filteredResults[indexPath.row].name
        } else {
            cell.textLabel?.text = repoList[indexPath.row].name
        }

        return cell
    }
    
    
    // MARK: SearchBar
    
    // Search bar
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
    }

}


extension RepositoriesTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredResults = repoList.filter({( item: Repository) -> Bool in
            return (item.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
    
}



extension RepositoriesTableViewController {
    
    func loadRepositoriesInformation()  {
        print(user!.repositoriesUrl!)
        
        Alamofire.request(user!.repositoriesUrl!).responseJSON(completionHandler: {
            response in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                
                return
            }
            
            self.parseData(JSONData: response.data!)
            
            self.tableView.reloadData()
        })
        
    }
    
    
    func parseData(JSONData: Data) {
        do {
            if let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: []) as? [String: AnyObject] {
            
                guard let name = readableJSON["name"] as? String,
                    let description = readableJSON["description"] as? String else {
                        return
                }
                    
                let repository = Repository(name: name, description: description)
                repoList.append(repository)
            }
        }
        catch {
            print(error)
        }
    }
}
