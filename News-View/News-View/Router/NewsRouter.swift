//
//  NewsRouter.swift
//  News-View
//
//  Created by BMF on 10.09.21.
//

import Foundation
import UIKit

class NewsRouter: NewsRouterProtocol {
    func makeViewController() -> ViewController {
        let viewController = ViewController(style: .plain)
        let interactor = NewsInteractor(newsView: viewController, networkService: NetworkDataFetcher())
        interactor.didStart()
        return viewController
    }
}
