//
//  FeedByGenreViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit

class FeedByGenreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var genreName: UILabel!
    
    var movies = [[String:Any]]()
    
    var genreId = Int()
    
    var genres = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()

        // Do any additional setup after loading the view.
        self.loadMovies(page: self.page)
        
        self.genreName.text = self.genres[self.genreId]! as String
    }
    
    func loadMovies(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&sort_by=popularity.desc&include_adult=false&include_video=false&page=" + String(page) + "&with_genres=" + String(self.genreId) + "&with_watch_monetization_types=flatrate")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies += dataDictionary["results"] as! [[String:Any]]
                // self.movies = Array(self.movies.prefix(18))
                self.collectionView.reloadData()
                // print(self.movies.count)
            }
        }
        task.resume()
    }
    
    func loadMoreMovies() {
        self.page += 1
        self.loadMovies(page: self.page)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        cell.posterView.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item + 1 == self.movies.count {
            self.loadMoreMovies()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movie = movie
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
