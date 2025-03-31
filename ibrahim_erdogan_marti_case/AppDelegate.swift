//
//  AppDelegate.swift
//  ibrahim_erdogan_marti_case
//
//  Created by İbrahim Erdogan on 31.03.2025.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

       func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {

           window = UIWindow(frame: UIScreen.main.bounds)
           let rootViewController = ViewController() // Kendi ViewController'ını burada kullan
           window?.rootViewController = rootViewController
           window?.makeKeyAndVisible()

           return true
       }
}

