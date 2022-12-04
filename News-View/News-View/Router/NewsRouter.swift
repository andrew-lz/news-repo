//
//  NewsRouter.swift
//  News-View
//
//  Created by BMF on 10.09.21.
//

import Foundation
import UIKit

class NewsRouter: NewsRouterProtocol {
    func makeViewController(with topic: String) -> ViewController {
        let viewController = ViewController()
        let interactor = NewsInteractor(newsView: viewController, networkService: NetworkDataFetcher(topic: topic))
        interactor.didStart()
        return viewController
    }
}
