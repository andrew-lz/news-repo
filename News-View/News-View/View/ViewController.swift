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
    
    private let refreshControl = UIRefreshControl()

    
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
    
    @objc private func refresh() {
        interactor?.refresh()
        navigationItem.searchController = nil
        refreshControl.endRefreshing()
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
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .clear
        refreshControl.backgroundColor = .black
        refreshControl.largeContentTitle = "Refreshing"
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.alwaysBounceVertical = true
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search by Title"
        searchController?.searchBar.tintColor = .cyan
        searchController?.searchBar.searchTextField.textColor = .white
        searchController?.searchBar.delegate = self
//        searchController?.searchBar.showsSearchResultsButton = true
        searchController?.searchBar.showsCancelButton = true
    }
    
    private func setupNavigationBar() {
//        navigationItem.searchController = searchController
//        navigationItem.searchController?.isActive = false
        navigationItem.rightBarButtonItem = createSearchButton()
        navigationItem.leftBarButtonItems = [createSortButton(), createAnalyzeButton()]
        navigationController?.navigationBar.barTintColor = .white
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        cell.setDelegate(delegate: self)
        cell.configure(with: newsModels[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        cell.getAllCellData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == newsModels.count, !searchController!.isActive {
            interactor?.loadNews()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor?.didTapCancelSearch()
        navigationItem.searchController = nil
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor?.filterSearch(searchText: searchBar.text ?? "")
    }
}

extension ViewController {
    func createSortButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(showSortAlert(_:)))
    }

    func createAnalyzeButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "doc"), style: .done, target: self, action: #selector(showLsaController(_:)))
    }

    func createSearchButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(showSearchBar(_:)))
    }
    
    @objc private func showSortAlert(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "By", message: nil, preferredStyle: .actionSheet)

        alert.view.tintColor = .black

        alert.addAction(UIAlertAction(title: "Author", style: .default, handler: { _ in
            self.interactor?.sortByAuthor()
        }))
        
        alert.addAction(UIAlertAction(title: "Date", style: .default, handler: { _ in
            print("Tapped on date action")
            self.interactor?.sortByPublishingDate()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func showLsaController(_ sender: UIBarButtonItem) {
        self.present(LsaTableViewController(collectionViewLayout: CollectionViewLayout()), animated: true)
    }

    @objc private func showSearchBar(_ sender: UIBarButtonItem) {
        navigationItem.searchController = searchController
        interactor?.printAnalyzedTable()
    }
}
