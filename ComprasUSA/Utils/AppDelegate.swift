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

  lazy var coreDataStack = CoreDataHelper(modelName: "ComprasUSA")

  static let shared: AppDelegate = {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
    }
    return delegate
  }()


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if UserDefaults.standard.value(forKey: UserDefaultsKeys.iof.rawValue) == nil {
      UserDefaults.standard.set("5.38", forKey: UserDefaultsKeys.iof.rawValue)
    }

    if UserDefaults.standard.value(forKey: UserDefaultsKeys.dolar.rawValue) == nil {
      UserDefaults.standard.set("5.19", forKey: UserDefaultsKeys.dolar.rawValue)
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

