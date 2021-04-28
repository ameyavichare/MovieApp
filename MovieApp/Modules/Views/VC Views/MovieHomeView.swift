//
//  MovieListingView.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import UIKit

///Responsible for the MovieHomeViewController view
class MovieHomeView: UIView {
    
    private(set) var tableView: UITableView!
    private(set) var searchController: UISearchController!
    private(set) var searchViewController: SearchViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.initialConfig()
        self.setupTable()
        self.setupSearchBar()
        self.setupSearchController()
    }
    
    private func initialConfig() {
        self.backgroundColor = .white
    }
    
    private func setupTable() {
        self.tableView = UITableView()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.addSubview(self.tableView)
        self.constrainToEdges(tableView)
    }
    
    private func setupSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Movies..."
        searchController.searchBar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupSearchController() {
        
        searchViewController = SearchViewController()
        searchViewController.view.isHidden = true
        self.addSubview(searchViewController.view)
        
        self.searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.searchViewController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.searchViewController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.searchViewController.view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 56).isActive = true
        self.searchViewController.view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
