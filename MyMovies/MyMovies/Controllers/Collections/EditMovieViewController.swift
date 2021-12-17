//
//  EditMovieViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 05/12/2021.
//

import UIKit
import Parse

class EditMovieViewController: UIViewController {
    
    var collection: PFObject?
    var movie: [String:Any]!
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        movieName.text = (movie["title"] as! String)
        
        let release_date = movie["release_date"] as! String
        let index = release_date.firstIndex(of: "-")!
        let year = String(release_date[..<index])
        movieYear.text = year
        
        movieSynopsis.text = (movie["overview"] as! String)
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        if (movie["backdrop_path"] as? String) != nil {
            let posterPath = movie["backdrop_path"] as! String
            let posterUrl = URL(string: baseUrl + posterPath)
            posterView.af.setImage(withURL: posterUrl!)
        }
        
        self.removeButton.layer.cornerRadius = 12
        self.removeButton.applyGradient(colors: [UIColor(named: "orange-coral")!.cgColor, UIColor(named: "pink-coral")!.cgColor])
    }
    
    func removeMovie() {
        var movie_ids = self.collection?["movie_ids"] as! Array<Int>
        var movie_info = self.collection?["movie_info"] as! [[String:Any]]
        let current_movie_id = self.movie["id"] as! Int
        let id_in_array = movie_ids.firstIndex(of: current_movie_id)!
        movie_ids.remove(at: id_in_array)
        movie_info.remove(at: id_in_array)
        self.collection?["movie_ids"] = movie_ids
        self.collection?["movie_info"] = movie_info
        self.collection?.saveInBackground { (success, error) in
            if success {
                print("Movie removed from collection")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onRemove(_ sender: Any) {
        // Create Alert
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this movie from the collection?", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.removeMovie()
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

}
