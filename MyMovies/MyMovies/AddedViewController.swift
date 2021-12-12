//
//  AddedViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse
import AlamofireImage

class AddedViewController: UIViewController {
    
    var movie: [String:Any]!
    var collection: PFObject?
    var existed = false

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    func addToCollection() {
        let current_movie_id = movie["id"] as! Int
        var movie_info = collection?["movie_info"] as! [[String:Any]]
        var current_movie_info = [String:Any]()
        let headUrl = "https://api.themoviedb.org/3/movie/"
        let tailUrl = "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
        let url = URL(string: headUrl + String(current_movie_id) + tailUrl)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                current_movie_info = dataDictionary
                movie_info.append(current_movie_info)
                self.collection?["movie_info"] = movie_info
                self.collection?.saveInBackground { (success, error) in
                    if success {
                        print("Movie added to collection")
                    } else {
                        print("Error: \(error?.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // self.addToCollection()
        // var info = collection?["movie_info"] as! [[String:Any]]
        // print("Info: \(info.count)")
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie["poster_path"] as! String
        posterView.af.setImage(withURL: URL(string: baseUrl + posterPath)!)
        
        let movie_name = movie["title"] as! String
        if existed {
            message.text = String(movie_name + " is already in this collection.")
        } else {
            self.addToCollection()
            message.text = String(movie_name + " has successfully been added to your collection!")
        }
        var ids = collection?["movie_ids"] as! Array<Int>
        print("Added: \(ids.count)")
    }
        
    @IBAction func onTap(_ sender: Any) {
        // self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        if let first = presentingViewController,
           let second = first.presentingViewController{
            first.view.isHidden = true
            second.dismiss(animated: true)
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

}
