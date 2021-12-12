//
//  ProfileViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(PFUser.current())

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if error == nil {
                // let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
                self.view.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                // self.present(Login, animated: true, completion: nil)
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
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
