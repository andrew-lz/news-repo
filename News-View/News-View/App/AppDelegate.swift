//
//  AppDelegate.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var newsRouter: NewsRouterProtocol = NewsRouter()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: newsRouter.makeViewController(with: "-m"))
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .landscape
    }
}
