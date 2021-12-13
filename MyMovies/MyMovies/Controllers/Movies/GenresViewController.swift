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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.rowHeight = 90

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableViewCell", for: indexPath) as! GenreTableViewCell
        let genrePair = self.genres[indexPath.row] as! [Int:String]
        for name in genrePair.values {
            cell.genreName.text = name
        }
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
