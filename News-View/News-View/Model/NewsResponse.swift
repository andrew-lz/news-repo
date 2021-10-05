//
//  News.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [Articles]
}

struct Articles: Decodable {
    let author: String?
    let title: String?
    let description: String
    let urlToImage: String?
    let publishedAt: String
}
