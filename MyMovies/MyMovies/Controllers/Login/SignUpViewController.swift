//
//  SignUpViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 11/12/2021.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameField.borderStyle = .roundedRect
        self.passwordField.borderStyle = .roundedRect
        
        self.signupButton.layer.cornerRadius = 12
        let pinkish = UIColor(named: "pinkish")!.cgColor
        let purpleish = UIColor(named: "purpleish")!.cgColor
        self.signupButton.applyGradient(colors: [pinkish, purpleish])

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user["collections"] = []
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                var dialogMsg = UIAlertController(title: "Cannot sign up", message: self.capitalizeFirstLetter(characters: error?.localizedDescription as! String), preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    
                }
                dialogMsg.addAction(ok)
                self.present(dialogMsg, animated: true, completion: nil)
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func capitalizeFirstLetter(characters: String) -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

}
