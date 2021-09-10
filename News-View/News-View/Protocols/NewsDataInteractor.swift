//
//  NewsDataPresenter.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation

protocol NewsDataInteractor {
    func refresh()
    func loadNews()
    func didStart()
}
