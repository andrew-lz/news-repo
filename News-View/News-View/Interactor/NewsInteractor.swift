//
//  NewsPresenter.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import Foundation
import UIKit

class NewsInteractor: NewsInteractorProtocol {
    private let newsView: NewsView
    private let networkDataFetcher: NetworkProtocol
    private var pageNumber: Int = 1
    private let daysQuantityBeforeRefresh = 8
    private var articles: [Article] = []
    private var filterStartTimer: Timer?
    required init(newsView: NewsView, networkService: NetworkProtocol) {
        self.newsView = newsView
        self.networkDataFetcher = networkService
        newsView.setDelegate(interactor: self)
    }
    func loadNews() {
        print("Load news")
        networkDataFetcher.loadNewsPage(before: self.pageNumber, then: { articles in
            self.articles.append(contentsOf: articles)
            DispatchQueue.main.async {
                self.newsView.configure(newsModels: self.createNewsModels(articles: self.articles))
            }
            self.newsView.stopAnimation()
        })
        pageNumber += 1
    }
    private func filteredArticles(searchText: String) -> [Article] {
        return articles.filter({ (article: Article) -> Bool in
            if let articleTitle = article.title {
                let titleMatch = articleTitle.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return titleMatch != nil
            } else {
                return "No Title".range(of: searchText, options: NSString.CompareOptions.caseInsensitive) != nil
            }
        }
        )
    }
    func filterSearch(searchText: String) {
        guard !searchText.isEmpty else { return }
        newsView.startAnimation(isSearchBarHidden: false)
        if filterStartTimer == nil {
            filterStartTimer = makeFilterTimer(for: searchText)
        } else {
            filterStartTimer?.invalidate()
            filterStartTimer = nil
            filterStartTimer = makeFilterTimer(for: searchText)
        }
    }
    private func makeFilterTimer(for searchText: String) -> Timer {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            DispatchQueue.main.async {
                self.newsView.configure(newsModels:
                                            self.createNewsModels(articles:
                                                                    self.filteredArticles(searchText: searchText)))
                self.newsView.stopAnimation()
                self.filterStartTimer = nil
            }
        }
        return timer
    }
    func didTapCancelSearch() {
        newsView.configure(newsModels: createNewsModels(articles: articles))
    }
    private func createNewsModels(articles: [Article]) -> [ArticleViewModel] {
        let newsModels = articles.map { article -> ArticleViewModel in
            let image = networkDataFetcher
                .loadImageFromUrl(stringUrl: article.urlToImage)
                .flatMap { UIImage(data: $0) } ?? UIImage()
            return ArticleViewModel(title: article.title ?? "No Title",
                                    author: article.author,
                                    description: article.description,
                                    image: image,
                                    publishedAt: article.publishedAt, isLiked: false)
        }
        return newsModels
    }
    func likeOrUnlikeArticle(index: Int, isLiked: Bool) {}
    func refresh() {
        newsView.resetModel()
        resetPagesQuantity()
        loadNews()
    }
    func didStart() {
        print("Did start")
        newsView.startAnimation(isSearchBarHidden: true)
        loadNews()
    }
    private func resetPagesQuantity() {
        pageNumber = 1
    }
}
