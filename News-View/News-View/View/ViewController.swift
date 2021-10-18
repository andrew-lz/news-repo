//
//  ViewController.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var interactor: NewsInteractorProtocol?
    private var newsModels: [ArticleViewModel] = []
    private var searchController: UISearchController?
    private var refreshControl = UIRefreshControl()
    private var loadingSpinner: UIActivityIndicatorView?
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
        setupSearchBar()
        setupRefreshControl()
        setupNavigationBar()
        setupTableView()
    }
    private func setupTableView() {
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    private func setupLoadingSpinner() {
         loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner?.color = .red
        loadingSpinner?.startAnimating()
        loadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = loadingSpinner
        self.tableView.tableFooterView?.isHidden = false
    }
    @objc private func refresh() {
        interactor?.refresh()
        searchController?.searchBar.isHidden = true
        searchController?.isActive = false
        setupLoadingSpinner()
        refreshControl.endRefreshing()
    }
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.backgroundColor = .black
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search by Title"
        searchController?.searchBar.tintColor = .cyan
        searchController?.searchBar.delegate = self
    }
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = createSortButton()
        navigationItem.leftBarButtonItem?.tintColor = .white
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier,
                                                 for: indexPath) as? ArticleTableViewCell
        cell?.setDelegate(delegate: self)
        cell?.configure(with: newsModels[indexPath.row])
        return cell ?? ArticleTableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        cell.didTapOnCell()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) <= 20,
           newsModels.count != 0 {
            setupLoadingSpinner()
            interactor?.loadNews()
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

extension ViewController {
    func createSortButton() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Sort", style: .done, target: self, action: #selector(showSimpleAlert(_:)))
    }
    @objc private func showSimpleAlert(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "By", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Author", style: .default, handler: { _ in
            self.navigationItem.leftBarButtonItem?.title = "Sorted by author"
        }))
        alert.addAction(UIAlertAction(title: "Date", style: .default, handler: { _ in
            self.navigationItem.leftBarButtonItem?.title = "Sorted by date"
        }))
        alert.addAction(UIAlertAction(title: "Favourites", style: .default, handler: { _ in
            self.navigationItem.leftBarButtonItem?.title = "Sorted by favourites"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.navigationItem.leftBarButtonItem?.title = "Sort"
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
