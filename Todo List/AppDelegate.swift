//
//  AppDelegate.swift
//  Todo List
//
//  Created by Aleksey Fedorov on 16.07.2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        do {
        _ = try Realm()
        } catch {
            print("Error installing new Realm, \(error)")
        }
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }

        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            
        }

        


}

