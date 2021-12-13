//
//  SearchViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var query: UILabel!
    @IBOutlet weak var numResults: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var searchQuery = String()
    var movies = [[String:Any]]()
    var page = 1
    var totalResults = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.rowHeight = 100
        
        self.query.text = searchQuery
        self.numResults.text = "Found " + String(self.totalResults) + " result for:"
        self.searchMovies(page: self.page)

        // Do any additional setup after loading the view.
    }
    
    func searchMovies(page: Int) {
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&query=" + self.searchQuery.replacingOccurrences(of: " ", with: "%20") + "&page=" + String(page) + "&include_adult=false")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies += dataDictionary["results"] as! [[String:Any]]
                self.totalResults = dataDictionary["total_results"] as! Int
                if (self.totalResults > 1) {
                    self.numResults.text = "Found " + String(self.totalResults) + " results for:"
                } else {
                    self.numResults.text = "Found " + String(self.totalResults) + " result for:"
                }
                // self.movies = Array(self.movies.prefix(18))
                self.tableView.reloadData()
                // print(self.movies.count)
            }
        }
        task.resume()
    }
    
    func searchMoreMovies() {
        self.page += 1
        self.searchMovies(page: self.page)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        let movie = self.movies[indexPath.row]
        cell.movieName.text = movie["title"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let poster = (movie["poster_path"] as? String) {
            let posterPath = movie["poster_path"] as! String
            let posterUrl = URL(string: baseUrl + posterPath)
            cell.thumbnail.af.setImage(withURL: posterUrl!)
        }
        cell.thumbnail.layer.cornerRadius = 5
        let genreIds = movie["genre_ids"] as! [Int]
        var genres = [String]()
        for id in genreIds {
            genres.append(self.genres[id]!)
        }
        cell.movieGenres.text = genres.joined(separator: ", ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.movies.count {
            self.searchMoreMovies()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
