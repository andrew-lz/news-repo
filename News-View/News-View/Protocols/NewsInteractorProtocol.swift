//
//  NewsDataPresenter.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation

protocol NewsInteractorProtocol: AnyObject {
    func refresh()
    func loadNews()
    func didStart()
    func filterSearch(searchText: String)
    func didTapCancelSearch()
    func sortByAuthor()
    func sortByPublishingDate()
}
