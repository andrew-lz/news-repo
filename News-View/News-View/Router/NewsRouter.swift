//
//  NewsRouter.swift
//  News-View
//
//  Created by BMF on 10.09.21.
//

import Foundation
import UIKit

class NewsRouter {
    
    func makeViewController() -> ViewController {
        let viewController = ViewController(style: .plain)
        let interactor = NewsInteractor(newsView: viewController)
        interactor.didStart()
        return viewController
    }
}
