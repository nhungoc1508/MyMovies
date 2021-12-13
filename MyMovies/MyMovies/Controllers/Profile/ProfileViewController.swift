//
//  ProfileViewController.swift
//  MyMovies
//
//  Created by Matthew Swartz on 12/3/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    //
    // Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    // displays total collections and movies saved
    @IBOutlet weak var collectionNumber: UILabel!
    @IBOutlet weak var movieNumber: UILabel!
    
    //
    // variables
    let currentUser = PFUser.current()
    var collections = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInfo()
    }
    
    // fetches our users information for the profile
    func loadInfo() {
        // update username label
        if self.currentUser != nil {
            usernameLabel.text = "@\((self.currentUser?.username)!)"
        }
        // get users collections
        let query = PFQuery(className:"Collection")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.includeKeys(["objectId", "owner", "name"])
        query.limit = 20

        // fetch data asynchronously
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                // calculating user collections
                self.collections = collections
                self.collectionNumber.text = String(collections.count)
                // calculating total movies
                var movies = 0
                for ind in 0...(collections.count - 1) {
                    let collection = collections[ind]
                    let ids = collection["movie_ids"] as! Array<Int>
                    movies += ids.count
                }
                self.movieNumber.text = String(movies)
                
            } else {
                print(error?.localizedDescription)
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
