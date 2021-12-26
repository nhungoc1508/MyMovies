//
//  SettingsViewController.swift
//  MyMovies
//
//  Created by Matthew Swartz on 12/3/21.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var privateCollectionsSwitch: UISwitch!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var picButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var displayname: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    let currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.logoutButton.layer.cornerRadius = 12
        self.logoutButton.applyGradient(colors: [UIColor(named: "orange-coral")!.cgColor, UIColor(named: "pink-coral")!.cgColor])
        
        self.username.borderStyle = .roundedRect
        self.addLeftImage(textfield: username, imageName: "person")
        
        self.displayname.borderStyle = .roundedRect
        self.addLeftImage(textfield: displayname, imageName: "textbox")
        
        loadInfo()
        
        self.picButton.layer.cornerRadius = 12
        self.infoButton.layer.cornerRadius = 12
        self.picButton.applyGradient(colors: [UIColor(named: "blueish")!.cgColor, UIColor(named: "purpleish2")!.cgColor])
        self.infoButton.applyGradient(colors: [UIColor(named: "pinkish")!.cgColor, UIColor(named: "purpleish")!.cgColor])
        
        // Do any additional setup after loading the view.
    }
    
    func loadInfo() {
        username.isEnabled = false
        if !username.isEnabled {
            username.backgroundColor = .systemGray6
        }
        if self.currentUser != nil {
            username.text = self.currentUser?.username!
        }
        
        displayname.isEnabled = false
        if !displayname.isEnabled {
            displayname.backgroundColor = .systemGray6
        }
        if self.currentUser != nil {
            displayname.text = self.currentUser?["displayName"] as! String
        }
    }
    
    func addLeftImage(textfield: UITextField, imageName: String) {
        // https://stackoverflow.com/questions/27903500/swift-add-icon-image-in-uitextfield
        textfield.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
        let image = UIImage(systemName: imageName)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.addSubview(imageView)
        
        textfield.leftView = view

        var config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20.0))
        imageView.tintColor = .systemGray
        imageView.preferredSymbolConfiguration = config
    }
    
    @IBAction func onEditInfo(_ sender: Any) {
        if !username.isEnabled || !displayname.isEnabled {
            username.isEnabled = true
            if username.isEnabled {
                username.backgroundColor = .white
            }
            displayname.isEnabled = true
            if displayname.isEnabled {
                displayname.backgroundColor = .white
            }
            infoButton.setTitle("Save changes", for: .normal)
        } else {
            if username.text!.count < 4 || username.text!.contains(" ") {
                alert(msg: "Username must contain at least 4 characters and no space.")
            } else {
                currentUser?.username = username.text
                if displayname.text == "" {
                    currentUser?["displayName"] = username.text
                } else {
                    currentUser?["displayName"] = displayname.text
                }
                currentUser?.saveInBackground { (success, error) in
                    if success {
                        self.alert(msg: "Information saved successfully")
                        self.infoButton.setTitle("Edit information", for: .normal)
                        self.loadInfo()
                    } else {
                        print("Error saving information: \(error?.localizedDescription)")
                        self.alert(msg: error?.localizedDescription ?? "Error saving new information")
                    }
                }
            }
        }
    }
    
    func alert(msg: String) {
        let dialogMessage = UIAlertController(title: "Edit information", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
//    @IBAction func backButtonPressed(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
            
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        delegate.window?.rootViewController = loginViewController
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
