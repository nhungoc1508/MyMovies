//
//  LaunchScreenViewController.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 17/12/2021.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGradientBackground()

        // Do any additional setup after loading the view.
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        let pinkish = UIColor(named: "pinkish")?.cgColor
        let purpleish = UIColor(named: "purpleish")?.cgColor
        let blueish = UIColor(named: "blueish")?.cgColor
        let purpleish2 = UIColor(named: "purpleish2")?.cgColor
        // gradientLayer.colors = [UIColor.blue.cgColor, UIColor.cyan.cgColor]
        gradientLayer.colors = [purpleish2, pinkish]
        // gradientLayer.colors = [blueish, purpleish2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
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
