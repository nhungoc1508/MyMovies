//
//  CollectionChoiceViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse

class CollectionChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movie: [String:Any]!
    var collections = [PFObject]()
    let currentUser = PFUser.current()

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        self.loadCollections()
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadCollections()
        self.tableView.reloadData()
    }
    
    func loadCollections() {
        let currentUser = PFUser.current()
        if currentUser != nil {
            usernameLabel.text = "@" + (currentUser?.username)!
        }
        let query = PFQuery(className:"Collection")
        let userId = (currentUser!.objectId)! as String
        // print(userId)
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.includeKeys(["owner", "name"])
        query.limit = 20

        // fetch data asynchronously
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                // print(collections.count)
                self.collections
                 = collections
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
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
             /// print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
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
                print("Error saving collection: \(error)")
            }
        }
        print(collections.count)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func getThumbnail(collection: PFObject) -> String {
        let ids = collection["movie_ids"] as! Array<Int>
        if (ids.count > 0) {
            let info = collection["movie_info"] as! [[String:Any]]
            return info[0]["poster_path"] as! String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionChoiceCell") as! CollectionChoiceCell
        
        let collection = collections[indexPath.row]
        let name = collection["name"] as! String
        cell.collectionName.text = name
        
        let movie_ids = collection["movie_ids"] as! Array<Int>
        let num_movies = movie_ids.count
        var num_movies_label = " movies"
        if (num_movies < 2) {
            num_movies_label = " movie"
        }
        cell.numMovies.text = String(String(num_movies) + num_movies_label)
        
        // let thumbnails = collection["thumbnails"] as! Array<String>
        let thumbnail = self.getThumbnail(collection: collection)
        if (thumbnail != "") {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            cell.thumbnail.af.setImage(withURL: URL(string: baseUrl + thumbnail)!)
            cell.thumbnail.layer.cornerRadius = cell.thumbnail.frame.size.width / 2
            cell.thumbnail.clipsToBounds = true
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as!UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let collection = collections[indexPath.row]
        
        let addedViewController = segue.destination as! AddedViewController
        addedViewController.collection = collection
        
        addedViewController.movie = movie
        
        let current_movie_id = movie["id"] as! Int
        var movie_ids = collection["movie_ids"] as! Array<Int>
        if (movie_ids.contains(current_movie_id)) {
            addedViewController.existed = true
            print("Movie already in collection")
        } else {
            movie_ids.append(current_movie_id)
            collection["movie_ids"] = movie_ids
            collection.saveInBackground { (success, error) in
                if success {
                    print("Movie added to collection")
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        // _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
