//
//  MovieDetailViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var movie: [String:Any]!
    var recs = [[String:Any]]()
    @IBOutlet weak var recsCollectionView: UICollectionView!
    
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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    
    var genre_ids = Array<Int>()
    @IBOutlet weak var genre0: UIButton!
    @IBOutlet weak var genre1: UIButton!
    @IBOutlet weak var genre2: UIButton!
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var movieSynopsis: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recsCollectionView.delegate = self
        self.recsCollectionView.dataSource = self
        self.recsCollectionView.reloadData()
        
        let pinkish = UIColor(named: "pinkish")!.cgColor
        let purpleish = UIColor(named: "purpleish")!.cgColor
        self.addButton.layer.cornerRadius = 12
        self.addButton.applyGradient(colors: [pinkish, purpleish])
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        // Do any additional setup after loading the view.
        movieName.text = (movie["title"] as! String)
        
        let release_date = movie["release_date"] as! String
        if release_date.contains("-") {
            let index = release_date.firstIndex(of: "-")!
            let year = String(release_date[..<index])
            movieYear.text = year
        } else {
            movieYear.text = ""
        }
        
        movieSynopsis.text = (movie["overview"] as! String)
        
        self.genre_ids = movie["genre_ids"] as! Array<Int>
        let genre_buttons = [self.genre0, self.genre1, self.genre2]
        let num_genres = min(3, self.genre_ids.count)
        for id in 0...(num_genres - 1) {
            genre_buttons[id]?.setTitle(self.genres[genre_ids[id]], for: .normal)
            genre_buttons[id]?.layer.cornerRadius = 5
        }
        if num_genres < 3 {
            for id in num_genres...2 {
                genre_buttons[id]?.isHidden = true
            }
        }
        
        if (self.movie["vote_average"] as! Double) > 0.0 {
            let rating = self.movie["vote_average"] as! Double
            self.score.text = String(rating) + "/10"
        } else {
            self.score.text = "N/A"
        }
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        if let poster = (movie["backdrop_path"] as? String) {
            let posterPath = movie["backdrop_path"] as! String
            let posterUrl = URL(string: baseUrl + posterPath)
            posterView.af.setImage(withURL: posterUrl!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getRecs(id: self.movie["id"] as! Int)
    }
    
    func getRecs(id: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + String(id) + "/recommendations?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.recs = dataDictionary["results"] as! [[String:Any]]
                self.recs = Array(self.recs.prefix(3))
                self.recsCollectionView.reloadData()
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recsCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        if indexPath.item < self.recs.count {
            let recMovie = self.recs[indexPath.item]
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let posterPath = recMovie["poster_path"] as! String
            let posterUrl = URL(string: baseUrl + posterPath)
            cell.posterView.af.setImage(withURL: posterUrl!)
            cell.posterView.layer.cornerRadius = 5
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addMovie" {
            let collectionChoiceController = segue.destination as! CollectionChoiceViewController
            collectionChoiceController.movie = movie
        } else if segue.identifier == "ShowMovieDetail" {
            let cell = sender as! UICollectionViewCell
            let indexPath = recsCollectionView.indexPath(for: cell)!
            let recMovie = self.recs[indexPath.item]
            
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = recMovie
            
            recsCollectionView.deselectItem(at: indexPath, animated: true)
        } else if segue.identifier == "ShowGenre0" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = self.genre_ids[0]
        } else if segue.identifier == "ShowGenre1" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = self.genre_ids[1]
        } else if segue.identifier == "ShowGenre2" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = self.genre_ids[2]
        }
    }

}
