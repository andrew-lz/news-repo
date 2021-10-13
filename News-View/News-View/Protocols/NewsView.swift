//
//  NewsView.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation

protocol NewsView {
    func configure(newsModels: [ArticleViewModel])
    func reloadData()
    func resetModel()
    func startAnimation(isSearchBarHidden: Bool)
    func stopAnimation()
    func setDelegate(interactor: NewsInteractorDelegate)
}
