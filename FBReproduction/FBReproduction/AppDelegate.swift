//
//  AppDelegate.swift
//  FBReproduction
//
//  Created by Dai Nguyen Khac on 2/22/20.
//  Copyright © 2020 Dai Nguyen Khac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    startApp()
    return true
  }
  
  private func startApp() {
    let rootViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "navigationRoot")
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
}

