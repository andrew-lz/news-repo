//
//  NewsRouter.swift
//  News-View
//
//  Created by BMF on 10.09.21.
//

import Foundation
import UIKit

class NewsRouter: NewsRouterProtocol {
    func makeNewsNavigationController() -> UINavigationController {
        let viewController = ViewController()
        let interactor = NewsInteractor(newsView: viewController, networkService: NetworkDataFetcher())
        interactor.didStart()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
