//
//  SocialCollectionViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 17/12/2021.
//

import UIKit
import Parse
import AlamofireImage

class SocialCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var collection: PFObject?
    var movie_ids = Array<Int>()
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        self.movie_ids = collection?["movie_ids"] as! Array<Int>
        let movie_count = movie_ids.count
        self.movies = self.collection?["movie_info"] as! [[String:Any]]

        // Do any additional setup after loading the view.
        collectionName.text = collection?["name"] as? String
        username.text = ((collection?["owner"] as! PFObject)["displayName"] as! String) + "'s collection"
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
