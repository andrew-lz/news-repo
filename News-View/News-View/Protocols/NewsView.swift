//
//  NewsView.swift
//  News-View
//
//  Created by BMF on 2.09.21.
//

import Foundation

protocol NewsView {
    func configure(newsModels: [NewsModel])
    func reloadData()
    func resetModel()
    func startAnimation()
    func stopAnimation()
}
