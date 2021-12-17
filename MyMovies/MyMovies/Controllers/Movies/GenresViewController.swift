//
//  GenresViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit

class GenresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var genres = [
        0: [28: "Action"],
        1: [12: "Adventure"],
        2: [16: "Animation"],
        3: [35: "Comedy"],
        4: [80: "Crime"],
        5: [99: "Documentary"],
        6: [18: "Drama"],
        7: [10751: "Family"],
        8: [14: "Fantasy"],
        9: [36: "History"],
        10: [27: "Horror"],
        11: [10402: "Music"],
        12: [9648: "Mystery"],
        13: [10749: "Romance"],
        14: [878: "Science Fiction"],
        15: [10770: "TV Movie"],
        16: [53: "Thriller"],
        17: [10752: "War"],
        18: [37: "Western"]
    ]
    
    var genres_backdrops = [
        28: "/r2GAjd4rNOHJh6i6Y0FntmYuPQW.jpg",
        12: "/7WJjFviFBffEJvkAms4uWwbcVUk.jpg",
        16: "/5RuR7GhOI5fElADXZb0X2sr9w5n.jpg",
        35: "/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg",
        80: "/vVpEOvdxVBP2aV166j5Xlvb5Cdc.jpg",
        99: "/3w23VLgYOs7gIkP4M5F25T8yUvK.jpg",
        18: "/6A5ugY49ukHmMLaMRwkjaKouzCn.jpg",
        10751: "/odKqOY6VE6C59YAdGHB0b5Havye.jpg",
        14: "/lyvszvJJqqI8aqBJ70XzdCNoK0y.jpg",
        36: "/vXMn5Acau1pW9hzun5P4yM7hQ6r.jpg",
        27: "/18qxSxzAUs7UjZ3dKCkxAOv0yb1.jpg",
        10402: "/jNUpYq2jRSwQM89vST9yQZelMSu.jpg",
        9648: "/U8QRD7jvTXEYsUXq74IFKaSiL5.jpg",
        10749: "/6VmFqApQRyZZzmiGOQq2C92jyvH.jpg",
        878: "/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
        10770: "/j3CSGG01PUh6nsju4oIfPGeoNQr.jpg",
        53: "/uWGPC7j70LE64nbetxQGSSYJO53.jpg",
        10752: "/pTwF9hLkqAtuOqXMdOyPwz4AgnI.jpg",
        37: "/p1eneBfZCGbbzicwksOhIaibUwk.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.rowHeight = 120

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableViewCell", for: indexPath) as! GenreTableViewCell
        let genrePair = self.genres[indexPath.row]!
        for name in genrePair.values {
            cell.genreName.text = name
        }
        var genreId = 18
        for id in genrePair.keys {
            genreId = id
        }
        cell.backdrop.layer.cornerRadius = 12
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let posterPath = self.genres_backdrops[genreId]!
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.backdrop.af.setImage(withURL: posterUrl!)
        
        cell.backdropOverlay.layer.cornerRadius = 12
        cell.backdropOverlay.applyGradient(colors: [UIColor(named: "pinkish")!.cgColor, UIColor(named: "purpleish")!.cgColor])
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let genrePair = self.genres[indexPath.row] as! [Int:String]
        var genreId = 18
        for id in genrePair.keys {
            genreId = id
        }
        
        let feedByGenre = segue.destination as! FeedByGenreViewController
        feedByGenre.genreId = genreId
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
