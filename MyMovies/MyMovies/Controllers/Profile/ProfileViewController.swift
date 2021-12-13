//
//  ProfileViewController.swift
//  MyMovies
//
//  Created by Matthew Swartz on 12/3/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    // Standards
    let defaults = UserDefaults.standard

    //
    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    // displays total collections and movies saved
    @IBOutlet weak var collectionNumber: UILabel!
    @IBOutlet weak var movieNumber: UILabel!
    
    // variables
    
    
    // saving to user defaults
    func save(_ key: String, _ value: Any) {
        defaults.set(value, forKey: "\(key)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInfo()
    }
    
    // fetches our users information for the profile
    func loadInfo() {
        // getting user from defaults
        // let username = defaults.string(forKey: "username")!
        let username = "matt"
        usernameLabel.text = "@\(username)"
        
        // fetching query for profile info
        let query = PFQuery(className: "User")
        query.whereKey("username", matchesText: "matt")
        query.includeKeys(["name", "collectionNumber", "movieNumber"])
        
        query.findObjectsInBackground() { (userDetails, error) in
            if userDetails != nil {
                // self.posts = posts!
                // self.tableView.reloadData()
                print(userDetails)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
