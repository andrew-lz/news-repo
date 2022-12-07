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
    private let lsaService: LsaService = LsaService()
    private var pageNumber: Int = 1
    private var articles: [Article] = []
    
    required init(newsView: NewsView, networkService: NetworkProtocol) {
        self.newsView = newsView
        self.networkDataFetcher = networkService
        newsView.setDelegate(interactor: self)
    }
    
    func loadNews() {
        newsView.startAnimation(isSearchBarHidden: false)
        networkDataFetcher.loadNewsPage(before: pageNumber, then: { articles in
            self.articles.append(contentsOf: articles)
            self.newsView.configure(newsModels: self.createNewsModels(articles: self.articles))
            self.newsView.stopAnimation()
        })
        pageNumber += 1
    }
    
    func sortByAuthor() {
        let emptyValue = "No Author"
        newsView.configure(newsModels: createNewsModels(articles: articles.sorted {
            $0.author ?? emptyValue > $1.author ?? emptyValue
        }))
    }
    
    func sortByPublishingDate() {
        let emptyValue = "No Date"
        newsView.configure(newsModels: createNewsModels(articles: articles.sorted {
            $0.publishedAt ?? emptyValue < $1.publishedAt ?? emptyValue
        }))
    }
    
    private func filteredArticles(searchText: String) -> [Article] {
        return articles.filter({ (article: Article) -> Bool in
            let articleDescription = article.description ?? "No Description"
            let descriptionMatch = articleDescription.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return descriptionMatch != nil
        }
        )
    }
    
    func filterSearch(searchText: String) {
        guard !searchText.isEmpty else { return }
        newsView.startAnimation(isSearchBarHidden: false)
        DispatchQueue.main.async {
            self.newsView.configure(newsModels: self.createNewsModels(articles: self.filteredArticles(searchText: searchText)))
            self.newsView.stopAnimation()
        }
    }
    
    func didTapCancelSearch() {
        resetPageNumber()
        newsView.configure(newsModels: createNewsModels(articles: articles))
    }
    
    private func createNewsModels(articles: [Article]) -> [ArticleViewModel] {
        let newsModels = articles.map { article -> ArticleViewModel in
            return ArticleViewModel(title: article.title ?? "No Title",
                                    author: article.author,
                                    description: article.description ?? "No Description",
                                    publishedAt: article.publishedAt ?? "No Date")
        }
        return newsModels
    }
    
    func refresh() {
        newsView.resetModel()
        resetPageNumber()
        loadNews()
    }
    
    func didStart() {
        print("Did start")
        loadNews()
    }
    
    private func resetPageNumber() {
        pageNumber = 1
    }

    func printAnalyzedTable() -> [ThemeStatistics] {
        self.lsaService.articles = articles
        let themesStatistics = lsaService.analyzeArticles(with: ["Themes"])
        for themeStatistics in themesStatistics {
            print(themeStatistics.theme)
            print(themeStatistics.articleAnalyze)
        }
        return themesStatistics
    }
}
