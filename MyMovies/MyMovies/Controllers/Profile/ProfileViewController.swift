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
    @IBOutlet weak var displaynameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    // displays total collections and movies saved
    @IBOutlet weak var collectionNumber: UILabel!
    @IBOutlet weak var movieNumber: UILabel!
    
    @IBOutlet weak var collectionCard: UIImageView!
    @IBOutlet weak var movieCard: UIImageView!
    //
    // variables
    let currentUser = PFUser.current()
    var collections = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInfo()
        
        self.collectionCard.layer.cornerRadius = 12
        self.collectionCard.applyGradient(colors: [UIColor(named: "blueish")!.cgColor, UIColor(named: "purpleish2")!.cgColor])
        self.movieCard.layer.cornerRadius = 12
        self.movieCard.applyGradient(colors: [UIColor(named: "purpleish2")!.cgColor, UIColor(named: "pinkish")!.cgColor])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadInfo()
    }
    
    // fetches our users information for the profile
    func loadInfo() {
        // update username label
        if self.currentUser != nil {
            displaynameLabel.text = self.currentUser?["displayName"] as! String
            usernameLabel.text = "@\((self.currentUser?.username)!)"
        }
        // get users collections
        let query = PFQuery(className:"Collection")
        if (PFUser.current() != nil) {
            query.whereKey("owner", equalTo: PFUser.current()!)
        }
        query.includeKeys(["objectId", "owner", "name"])
        query.limit = 20

        // fetch data asynchronously
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                // calculating user collections
                self.collections = collections
                if collections.count > 1 {
                    self.collectionNumber.text = String(collections.count) + " collections"
                } else {
                    self.collectionNumber.text = String(collections.count) + " collection"
                }
                // calculating total movies
                var movies = 0
                if collections.count > 0 {
                    for ind in 0...(collections.count - 1) {
                        let collection = collections[ind]
                        let ids = collection["movie_ids"] as! Array<Int>
                        movies += ids.count
                    }
                    if movies > 1 {
                        self.movieNumber.text = String(movies) + " movies"
                    } else {
                        self.movieNumber.text = String(movies) + " movie"
                    }
                } else {
                    self.movieNumber.text = "0 movie"
                }
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

extension UIImageView
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 12
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
