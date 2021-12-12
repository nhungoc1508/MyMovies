//
//  MovieDetailViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {
    
    var movie: [String:Any]!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    
    @IBOutlet weak var genre0: UILabel!
    @IBOutlet weak var genre1: UILabel!
    @IBOutlet weak var genre3: UILabel!
    
    @IBOutlet weak var movieSynopsis: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        // Do any additional setup after loading the view.
        movieName.text = movie["title"] as! String
        
        let release_date = movie["release_date"] as! String
        let index = release_date.firstIndex(of: "-")!
        let year = String(release_date[..<index])
        movieYear.text = year
        
        movieSynopsis.text = movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        if let poster = (movie["backdrop_path"] as? String) {
            let posterPath = movie["backdrop_path"] as! String
            let posterUrl = URL(string: baseUrl + posterPath)
            posterView.af.setImage(withURL: posterUrl!)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let collectionChoiceController = segue.destination as! CollectionChoiceViewController
        collectionChoiceController.movie = movie
    }

}
