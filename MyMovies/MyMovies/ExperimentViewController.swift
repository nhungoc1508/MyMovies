//
//  ExperimentViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 05/12/2021.
//

import UIKit

class ExperimentViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        let subviewHeight = CGFloat(120)
        var currentViewOffset = CGFloat(0);
        
        while currentViewOffset < contentHeight {
            let frame = CGRect(x: 0, y: currentViewOffset, width: contentWidth, height: subviewHeight).insetBy(dx: 5, dy: 5)
            let hue = currentViewOffset/contentHeight
            let subview = UIView(frame: frame)
            subview.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            // scrollView.addSubview(subview)
            
            currentViewOffset += subviewHeight
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        // Create Alert
//        var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to remove this movie from the collection?", preferredStyle: .alert)
//        // Create OK button with action handler
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("Ok button tapped")
//            print("Do sth")
//        })
//        // Create Cancel button with action handlder
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//            print("Cancel button tapped")
//        }
//        //Add OK and Cancel button to an Alert object
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//        // Present alert message to user
//        self.present(dialogMessage, animated: true, completion: nil)
        // Declare Alert message
//        let dialogMessage = UIAlertController(title: "Add a new collection", message: "What do you want to call your collection?", preferredStyle: .alert)
//        // Add text field
//        dialogMessage.addTextField(configurationHandler: { textField in
//            textField.text = "Untitled"
//        })
//        // Create OK button with action handler
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("Ok button tapped")
//            print("Name = \(dialogMessage.textFields?.first?.text ?? "")")
//        })
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//            print("Cancel button tapped")
//        }
//
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//        self.present(dialogMessage, animated: true, completion: nil)
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
