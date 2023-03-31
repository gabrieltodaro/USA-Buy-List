//
//  AppDelegate.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 02/03/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if UserDefaults.standard.value(forKey: UserDefaultsKeys.dolar.rawValue) == nil {
      UserDefaults.standard.set("3.2", forKey: UserDefaultsKeys.dolar.rawValue)
    }

    if UserDefaults.standard.value(forKey: UserDefaultsKeys.iof.rawValue) == nil {
      UserDefaults.standard.set("6.38", forKey: UserDefaultsKeys.iof.rawValue)
    }

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

}

