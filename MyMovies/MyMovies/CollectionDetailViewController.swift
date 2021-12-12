//
//  CollectionDetailViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse
import AlamofireImage

class CollectionDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collection: PFObject?
    var movie_ids = Array<Int>()
    var movies = [[String:Any]]()
    let currentUser = PFUser.current()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionName: UILabel!
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    func reloadCollection() {
        let collectionId = self.collection?.objectId as! String
        let query = PFQuery(className:"Collection")
        query.whereKey("objectId", equalTo:collectionId)
        query.includeKeys(["owner", "name", "movie_ids", "movie_info"])
        query.limit = 1
        
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                self.collection
                    = collections[0]
                self.movies = self.collection?["movie_info"] as! [[String:Any]]
                self.movie_ids = self.collection?["movie_ids"] as! Array<Int>
                let movie_count = self.movie_ids.count
                if (movie_count > 0) {
                    self.emptyLabel.text = ""
                } else {
                    self.emptyLabel.text = "This collection is empty. Browse & add movies now!"
                }
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.reloadCollection()
        collectionView.reloadData()

        // Do any additional setup after loading the view.
        collectionName.text = collection?["name"] as! String
        self.movie_ids = collection?["movie_ids"] as! Array<Int>
        let movie_count = movie_ids.count
        if (movie_count > 0) {
            emptyLabel.text = ""
            self.movies = self.collection?["movie_info"] as! [[String:Any]]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadCollection()
        self.collectionView.reloadData()
    }
    
    func deleteCollection() {
        var objs_arr = self.currentUser?["collections"] as! Array<PFObject>
        let current_id = self.collection?.objectId as! String
        var ids_arr = Array<String>()
        for obj in objs_arr {
            ids_arr.append(obj.objectId as! String)
        }
        let id_in_arr = ids_arr.firstIndex(of: current_id) as! Int
        objs_arr.remove(at: id_in_arr)
        self.currentUser?["collections"] = objs_arr
        self.currentUser?.saveInBackground { (success, error) in
            if success {
                print("Collection removed from current user's array")
            } else {
                print("Error while removing from user's array: \(error?.localizedDescription)")
            }
        }
        self.collection?.deleteInBackground { (success, error) in
            if success {
                print("Collection deleted")
            } else {
                print("Error while deleting collection: \(error?.localizedDescription)")
            }
        }
    }
    
    func renameCollection(newName: String) {
        self.collection?["name"] = newName
        self.collection?.saveInBackground { (success, error) in
            if success {
                print("Renamed collection")
                self.reloadCollection()
                self.collectionName.text = self.collection?["name"] as! String
            } else {
                print("Error while renaming collection: \(error)")
            }
        }
    }
    
    @IBAction func onRename(_ sender: Any) {
        self.reloadCollection()
        let dialogMessage = UIAlertController(title: "Rename collection", message: "What do you want to call your collection?", preferredStyle: .alert)
        // Add text field
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter collection name"
            textField.text = self.collection?["name"] as! String
        })
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             // print("Ok button tapped")
             // print("Name = \(dialogMessage.textFields?.first?.text ?? "")")
            let newName = dialogMessage.textFields?.first?.text as! String
            if (newName != "") {
                self.renameCollection(newName: dialogMessage.textFields?.first?.text as! String)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
             // print("Cancel button tapped")
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        // Create Alert
        var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this collection?", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.deleteCollection()
            _ = self.navigationController?.popViewController(animated: true)
        })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movie_ids.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionGridCell", for: indexPath) as! MovieCollectionGridCell
        // print("==================================")
        // print((self.collection?["movie_info"] as! [[String:Any]]).count)
        let movie = self.movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        cell.posterView.layer.cornerRadius = 5
        cell.posterView.clipsToBounds = true
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        let detailViewController = segue.destination as! EditMovieViewController
        detailViewController.movie = movie
        detailViewController.collection = self.collection
        // print(movie)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
