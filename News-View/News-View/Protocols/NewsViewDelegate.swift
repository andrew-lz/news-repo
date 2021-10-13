//
//  NewsDataPresenter.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation

protocol NewsViewDelegate: AnyObject {
    func refresh()
    func loadNews()
    func didStart()
    func filterSearch(searchText: String)
    func didTapCancelSearch()
    func saveArticle(index: Int, isLiked: Bool)
    func deleteArticle(index: Int, isLiked: Bool)
    func configureFavouriteArticles()
}

