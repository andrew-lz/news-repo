//
//  ViewController.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import UIKit

class ViewController: UITableViewController {
    private var interactor: NewsInteractorProtocol?
    private var newsModels: [ArticleViewModel] = []
    private var searchController: UISearchController?
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = .purple
        loadingIndicator.style = .large
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingIndicator)
        setupRefreshControl()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        setupSearchBar()
    }
    @objc private func refresh() {
        interactor?.refresh()
        searchController?.searchBar.isHidden = true
        searchController?.isActive = false
        refreshControl?.endRefreshing()
    }
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .clear
        refreshControl?.backgroundColor = .black
        refreshControl!.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search by Title"
        searchController?.searchBar.tintColor = .cyan
        searchController?.searchBar.delegate = self
        tableView.tableHeaderView = searchController?.searchBar
    }
    @objc private func filter() {
        guard let searchText = searchController?.searchBar.text else { return }
        interactor?.filterSearch(searchText: searchText)
    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            perform(#selector(filter), with: nil, afterDelay: 2.0)
        }
    }
}

extension ViewController: NewsView {
    func configure(newsModels: [ArticleViewModel]) {
        self.newsModels = newsModels
        reloadData()
    }
    func setDelegate(interactor: NewsInteractorProtocol) {
        self.interactor = interactor
    }
    func resetModel() {
        newsModels = []
        reloadData()
    }
    func reloadData() {
        tableView.reloadData()
    }
    func startAnimation(isSearchBarHidden: Bool) {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
        searchController?.searchBar.isHidden = isSearchBarHidden
        loadingIndicator.startAnimating()
    }
    func stopAnimation() {
        loadingIndicator.stopAnimating()
        searchController?.searchBar.isHidden = false
    }
}

extension ViewController: ArticleTableViewCellDelegate {
    func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier,
                                                 for: indexPath) as? ArticleTableViewCell
        cell?.setDelegate(delegate: self)
        cell?.configure(with: newsModels[indexPath.row])
        return cell ?? ArticleTableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentSize.height - tableView.frame.height < tableView.contentOffset.y {
            if searchController?.isActive == false {
                interactor?.loadNews()
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor?.didTapCancelSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.filterSearch(searchText: searchBar.text ?? "")
    }
}
