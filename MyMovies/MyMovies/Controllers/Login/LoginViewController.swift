//
//  LoginViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.borderStyle = .roundedRect
        self.passwordField.borderStyle = .roundedRect
        
        self.addRightImage(textfield: usernameField, imageName: "person")
        self.addRightImage(textfield: passwordField, imageName: "key")
        
        self.logInButton.layer.cornerRadius = 12
        let pinkish = UIColor(named: "pinkish")!.cgColor
        let purpleish = UIColor(named: "purpleish")!.cgColor
        self.logInButton.applyGradient(colors: [pinkish, purpleish])
        
        self.validateAll()

        // Do any additional setup after loading the view.
    }
    
    func addRightImage(textfield: UITextField, imageName: String) {
        textfield.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
        let image = UIImage(systemName: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(imageView)
        
        textfield.rightView = view

        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0))
        imageView.tintColor = .systemGray
        imageView.preferredSymbolConfiguration = config
    }
    
    func validateAll() {
        if usernameField.text == "" || passwordField.text == "" {
            logInButton.isEnabled = false
            logInButton.alpha = 0.5
        } else {
            logInButton.isEnabled = true
            logInButton.alpha = 1
        }
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        self.validateAll()
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        self.validateAll()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                var dialogMsg = UIAlertController(title: "Cannot log in", message: self.capitalizeFirstLetter(characters: error?.localizedDescription as! String), preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    
                }
                dialogMsg.addAction(ok)
                self.present(dialogMsg, animated: true, completion: nil)
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
    
    func capitalizeFirstLetter(characters: String) -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

}

extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 12
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
