//
//  FeedViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import AlamofireImage

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        searchBar.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/trending/movie/week?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = Array(self.movies.prefix(18))
                self.collectionView.reloadData()
                print(self.movies.count)
            }
        }
        task.resume()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            performSegue(withIdentifier: "Search", sender: self)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
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
    
    @IBAction func onTapAction(_ sender: Any) {
    }
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ShowMovieDetail", sender: indexPath)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMovieDetail" {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let movie = movies[indexPath.item]
            
            let detailViewController = segue.destination as! MovieDetailViewController
            detailViewController.movie = movie
            
            collectionView.deselectItem(at: indexPath, animated: true)
        } else if segue.identifier == "FeedAction" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = 28
        } else if segue.identifier == "FeedComedy" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = 35
        } else if segue.identifier == "FeedFantasy" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = 14
        } else if segue.identifier == "FeedScifi" {
            let feedByGenre = segue.destination as! FeedByGenreViewController
            feedByGenre.genreId = 878
        } else if segue.identifier == "Search" {
            if (self.searchBar.text != nil) {
                let searchQuery = self.searchBar.text as! String
                let searchView = segue.destination as! SearchViewController
                 searchView.searchQuery = searchQuery
            }
        }
    }
    
}
