//
//  AppDelegate.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var newsRouter: NewsRouterProtocol = NewsRouter()
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = newsRouter.makeViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
