//
//  SocialViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 17/12/2021.
//

import UIKit
import Parse
import AlamofireImage

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let myRefreshControl = UIRefreshControl()
    var collections = [PFObject]()
    let currentUser = PFUser.current()
    var limit = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.rowHeight = 404
        loadCollections(limit: self.limit)
        
        myRefreshControl.addTarget(self, action: #selector(loadCollections), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCollections(limit: self.limit)
    }
    
    @objc func loadCollections(limit: Int) {
        let query = PFQuery(className:"Collection")
        query.whereKey("owner", notEqualTo: PFUser.current()!)
        query.includeKeys(["objectId", "owner", "name"])
        query.limit = limit
        
        // fetch data asynchronously
        query.findObjectsInBackground { (collections: [PFObject]?, error: Error?) in
            if let collections = collections {
                // print(collections.count)
                self.collections
                    = collections
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func loadMoreColelctions() {
        self.limit += 10
        self.loadCollections(limit: self.limit)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialTableViewCell", for: indexPath) as! SocialTableViewCell
        if indexPath.row < self.collections.count {
            let collection = self.collections[indexPath.row]
            cell.collectionName.text = collection["name"] as? String
            let owner = collection["owner"] as! PFObject
            cell.username.text = "@" + (owner["username"] as? String)!
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width / 2
            cell.profilePic.clipsToBounds = true
            if owner["profilePicture"] != nil {
                let imageFile = owner["profilePicture"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!
                cell.profilePic.af.setImage(withURL: url)
            }
            
            let ids = collection["movie_ids"] as! Array<Int>
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
            }
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == self.collections.count {
//            self.loadMoreCollections()
//        }
//    }
    
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
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as!UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let collection = collections[indexPath.row]
        
        let detailViewController = segue.destination as! SocialCollectionViewController
        detailViewController.collection = collection
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
