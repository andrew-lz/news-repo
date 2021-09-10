//
//  ViewController.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import UIKit

class ViewController: UITableViewController, NewsView, UISearchResultsUpdating {
    
    private var changedCell: CustomTableViewCell?
    
    private var newsModels: [NewsModel] = []
    
    private var searchResults: [NewsModel] = []
    
    private var searchController: UISearchController!
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.color = .purple
        loadingIndicator.style = .large
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.hidesWhenStopped = true
        
        return loadingIndicator
    }()
    
    func configure(newsModels: [NewsModel]) {
        self.newsModels.append(contentsOf: newsModels)
        reloadData()
    }
    override init(style: UITableView.Style) {
        super.init(style: style)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didTapOnReadmore"), object: nil, queue: OperationQueue.current) { _ in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func resetModel() {
        newsModels = []
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    
    func startAnimation() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor).isActive = true
        searchController.searchBar.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func stopAnimation() {
        loadingIndicator.stopAnimating()
        searchController.searchBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingIndicator)
        setupRefreshControl()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        setupSearchBar()
        updateSearchResults(for: searchController)
    }
    
    @objc private func refresh() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pulledToRefresh"), object: nil)
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
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Title"
        searchController.searchBar.tintColor = .cyan
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        searchResults = newsModels.filter({ (news: NewsModel) -> Bool in
            let titleMatch = news.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return titleMatch != nil
        }
        )
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return newsModels.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        if searchController.isActive {
            cell.configure(with: searchResults[indexPath.row])
        } else {
            cell.configure(with: newsModels[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == (newsModels.count - 1)) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didScrollToTheEnd"), object: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row + 1)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

