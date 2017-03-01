//
//  UsersListTableViewController.swift
//  GithubAPIExample
//
//  Created by Francini Carvalho on 26/02/17.
//  Copyright © 2017 Francini Carvalho. All rights reserved.
//

import UIKit
import Alamofire

class UsersListTableViewController: UITableViewController {

    var usersList = [User]()
    var filteredResults = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    let githubUrl = "https://api.github.com/search/users?q=repos:%3E100+followers:%3E1000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        

        loadUsersInformation()
        
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResults.count
        }
        
        return usersList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.textLabel?.text = filteredResults[indexPath.row].login
        } else {
            cell.textLabel?.text = usersList[indexPath.row].login
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "showUserDetails" {
            if let repositoriesVC = segue.destination as? RepositoriesTableViewController {
                repositoriesVC.user = usersList[tableView.indexPathForSelectedRow!.row]
            }
        }
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

extension UsersListTableViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredResults = usersList.filter({( item: User) -> Bool in
            return (item.login?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }    
}


extension UsersListTableViewController {
    
    func loadUsersInformation()  {
        Alamofire.request(githubUrl).responseJSON(completionHandler: {
            response in
            
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(response.result.error)")
                
                return
            }
            
            self.parseData(JSONData: response.data!)
            print("usuarios: ", self.usersList.count)
            self.tableView.reloadData()
        })
        
    }
    
    
    func parseData(JSONData: Data) {
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
