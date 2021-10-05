//
//  NewsPresenter.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import Foundation
import UIKit

class NewsInteractor: NewsDataInteractor {
    
    private let newsView: NewsView
    private let networkDataFetcher = NetworkDataFetcher()
    private var dayNumber: Int?
    private let daysQuantityBeforeRefresh = 8
    
    required init(newsView: NewsView) {
        self.newsView = newsView
        newsView.setDelegate(interactor: self)
        resetDaysQuantity()
    }
    
    func loadNews() {
        newsView.startAnimation()
        var newsModels = [NewsModel]()
        networkDataFetcher.loadNewsPage(before: dayNumber!, then: { news in
            news.articles.forEach { article in
                newsModels.append(NewsModel(title: article.title ?? "No Title", author: article.author, description: article.description, image: UIImage(data: try! Data(contentsOf: URL(string: article.urlToImage ?? "https://s2.coinmarketcap.com/static/img/coins/200x200/1.png")!))!, publishedAt: article.publishedAt))
                print(article.title ?? "No Title")
            }
            self.newsView.configure(newsModels: newsModels)
            self.newsView.stopAnimation()
        })
        dayNumber! += 1
    }
    
    func refresh() {
        newsView.resetModel()
        resetDaysQuantity()
        loadNews()
    }
    
    func didStart() {
        print("Did start")
        loadNews()
    }
    
    private func resetDaysQuantity() {
        dayNumber = 1
    }
}
