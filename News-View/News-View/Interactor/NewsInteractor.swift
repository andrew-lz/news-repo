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
    private var daysQuantity: Int?
    private let daysQuantityBeforeRefresh = 8
    private var observer: NSObjectProtocol?
    
    required init(newsView: NewsView) {
        self.newsView = newsView
        resetDaysQuantity()
        initPaginationObserver()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "pulledToRefresh"), object: nil, queue: OperationQueue.current) { notification in
            self.refresh()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loadNews() {
        newsView.startAnimation()
        var newsModels = [NewsModel]()
        networkDataFetcher.loadNewsPage(before: daysQuantity!, then: { news in
            news.articles.forEach { article in
                newsModels.append(NewsModel(title: article.title, author: article.author, description: article.description, image: UIImage(data: try! Data(contentsOf: URL(string: article.urlToImage ?? "https://s2.coinmarketcap.com/static/img/coins/200x200/1.png")!))!, publishedAt: article.publishedAt))
            }
            self.newsView.configure(newsModels: newsModels)
            self.newsView.stopAnimation()
        })
        daysQuantity! += 1
    }
    
    @objc func refresh() {
        newsView.resetModel()
        resetDaysQuantity()
        initPaginationObserver()
        loadNews()
    }
    
    func didStart() {
        print("Did start")
        loadNews()
    }
    
    private func resetDaysQuantity() {
        daysQuantity = 1
    }
    
    private func initPaginationObserver() {
        if observer == nil {
            observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didScrollToTheEnd"), object: nil, queue: OperationQueue.current) { notification in
                if self.daysQuantity! == self.daysQuantityBeforeRefresh {
                    if self.observer != nil{
                        NotificationCenter.default.removeObserver(self.observer!)
                        self.observer = nil
                    }
                } else {
                    self.loadNews()
                }
            }
        }
    }
}
