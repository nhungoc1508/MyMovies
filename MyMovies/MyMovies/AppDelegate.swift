//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Ngoc Hoang on 03/12/2021.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let parseConfig = ParseClientConfiguration {
                    $0.applicationId = "FlbD0r4foep7pCGoseLBSLrNOpml5jou0XcOMYly"
                    $0.clientKey = "UnoBHx7x4Mn5PcNACzUETBNbdaOhZGyFAnhY5AR9"
                    $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
//        if PFUser.current() != nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            // view controller currently being set in Storyboard as default will be overridden
//            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

