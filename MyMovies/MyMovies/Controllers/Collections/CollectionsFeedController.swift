//
//  CollectionsFeedController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse
import AlamofireImage

class CollectionsFeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var newButton: UIButton!
    var collections = [PFObject]()
    let currentUser = PFUser.current()
    
    func loadCollections() {
        if self.currentUser != nil {
            usernameLabel.text = "@" + (self.currentUser?.username)!
        }
        let query = PFQuery(className:"Collection")
        // query.includeKeys(["author", "comments", "comments.author"]) // get the author object not just the pointer
        let userId = (self.currentUser!.objectId)! as String
        // print(userId)
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.includeKeys(["objectId", "owner", "name"])
        query.limit = 20

        // fetch data asynchronously
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                // print(collections.count)
                self.collections
                 = collections
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        self.loadCollections()
        tableView.reloadData()
        
        tableView.rowHeight = 353
        
        let pinkish = UIColor(named: "pinkish")!.cgColor
        let purpleish = UIColor(named: "purpleish")!.cgColor
        self.newButton.layer.cornerRadius = 12
        self.newButton.applyGradient(colors: [pinkish, purpleish])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadCollections()
        self.tableView.reloadData()
    }
    
    func getThumbnails(collection: PFObject, count: Int) -> Array<String> {
        if (count > 0) {
            let info = collection["movie_info"] as! [[String:Any]]
            var thumbnails = Array<String>()
            let endOfArray = min(4, count-1)
            for i in 0...endOfArray {
                var posterPath = info[i]["poster_path"] as! String
                thumbnails.append(posterPath)
            }
            return thumbnails
        }
        return Array<String>()
    }
    
    func saveCollection(name: String) {
        let newCollection = PFObject(className: "Collection")
        newCollection["name"] = name
        newCollection["owner"] = self.currentUser
        newCollection["movie_ids"] = Array<Int>()
        newCollection["movie_info"] = [[String:Any]]()
        currentUser?.add(newCollection, forKey: "collections")
        currentUser?.saveInBackground { (success, error) in
            if success {
                self.loadCollections()
                self.tableView.reloadData()
                print("Collection saved")
            } else {
                print("Error saving collection: \(error?.localizedDescription)")
            }
        }
        print(collections.count)
    }
    
    @IBAction func addCollection(_ sender: Any) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Add a new collection", message: "What do you want to call your collection?", preferredStyle: .alert)
        // Add text field
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter collection name"
            textField.text = "Untitled"
        })
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            // print("Ok button tapped")
            // print("Name = \(dialogMessage.textFields?.first?.text ?? "")")
            let name = dialogMessage.textFields?.first?.text as! String
            if (name != "") {
                self.saveCollection(name: name)
            } else {
                self.saveCollection(name: "Untitled")
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") as! CollectionCell
        let collection = collections[indexPath.row]
        let name = collection["name"] as! String
        cell.collectionName.text = name
        let ids = collection["movie_ids"] as! Array<Int>
        var num_movies_label = " movies"
        if (ids.count < 2) {
            num_movies_label = " movie"
        }
        cell.numMovies.text = String(String(ids.count) + num_movies_label)
        
        let thumbnails = self.getThumbnails(collection: collection, count: ids.count)
        
        cell.posterView0.layer.cornerRadius = 20
        cell.posterView0.layer.maskedCorners = [.layerMinXMinYCorner]
        cell.posterView1.layer.cornerRadius = 20
        cell.posterView1.layer.maskedCorners = [.layerMaxXMinYCorner]
        cell.posterView2.layer.cornerRadius = 20
        cell.posterView2.layer.maskedCorners = [.layerMinXMaxYCorner]
        cell.posterView4.layer.cornerRadius = 20
        cell.posterView4.layer.maskedCorners = [.layerMaxXMaxYCorner]
        var posterViews = Array<UIImageView>()
        posterViews.append(cell.posterView0)
        posterViews.append(cell.posterView1)
        posterViews.append(cell.posterView2)
        posterViews.append(cell.posterView3)
        posterViews.append(cell.posterView4)
        

        for poster in posterViews {
            poster.image = nil
        }
        
        if (!thumbnails.isEmpty) {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            
            for i in 0...(thumbnails.count-1) {
                var cur_poster = posterViews[i]
                cur_poster.af.setImage(withURL: URL(string: baseUrl + thumbnails[i])!)
            }
//            for i in thumbnails.count...4 {
//                posterViews[i].image = nil
//            }
        }
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // sender: the cell that gets tapped on
//        // Find the selected movie
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)!
//        let collection = collections[indexPath.row]
//
//        let collectionDetailViewController = segue.destination as! CollectionDetailViewController
//        collectionDetailViewController.collection = collection
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as!UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let collection = collections[indexPath.row]
        
        let detailViewController = segue.destination as! CollectionDetailViewController
        detailViewController.collection = collection
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
