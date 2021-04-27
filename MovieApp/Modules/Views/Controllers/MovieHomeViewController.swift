//
//  MovieListingViewController.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import UIKit
import Combine

class MovieHomeViewController: UIViewController {
    
    private let vm = MovieHomeViewModel()
    private let movieHomeView = MovieHomeView()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindVM()
        self.vm.viewDidLoad()
    }
    
    //MARK:- Bind VM
    private func bindVM() {
        self.vm.$dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (dataSource) in
                guard let weakSelf = self else { return }
                weakSelf.movieHomeView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        self.vm.$filteredDataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (dataSource) in
                guard let weakSelf = self else { return }
                weakSelf.movieHomeView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        self.vm.movieChoosed
            .sink { [weak self] (vm) in
                guard let weakSelf = self else { return }
                weakSelf.pushMovieDetail(with: vm)
            }
            .store(in: &cancellables)
    }
    
    //MARK:- VC Setup
    private func setupUI() {
        self.configureTableView()
        self.configureSearch()
    }
    
    private func configureTableView() {
        self.movieHomeView.tableView.delegate = self
        self.movieHomeView.tableView.dataSource = self
        MovieTableViewCell.registerWithTable(self.movieHomeView.tableView)
    }
    
    private func configureSearch() {
        self.movieHomeView.searchController.searchResultsUpdater = self
        self.movieHomeView.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        
        addChild(self.movieHomeView.searchViewController)
        self.movieHomeView.searchViewController.didMove(toParent: self)
        view.bringSubviewToFront(self.movieHomeView.searchViewController.view)
    }
    
    override func loadView() {
        super.loadView()
        self.view = movieHomeView
    }
}

//MARK:- TableView datasource & delegate
extension MovieHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.vm.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.vm.vmAtIndex(indexPath.row)
        return cellForMovie(vm, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieVM = self.vm.vmAtIndex(indexPath.row)
        self.vm.storeMovie(movieVM)
        self.pushMovieDetail(with: movieVM)
    }
}

//MARK:- TableView cell config
extension MovieHomeViewController {

    private func cellForMovie(_ vm: MovieViewModel, indexPath: IndexPath) -> MovieTableViewCell {
        let cell = self.movieHomeView.tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- Search delegates
extension MovieHomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension MovieHomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !self.vm.isSearching {
            self.movieHomeView.searchViewController.view.isHidden = false
        }
        self.vm.setIsSearching(as: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.count > 0 {
            self.movieHomeView.searchViewController.view.isHidden = true
        }
        else {
            self.movieHomeView.searchViewController.view.isHidden = false
        }
        self.vm.searchMovies(with: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.vm.setIsSearching(as: false)
        self.movieHomeView.tableView.reloadData()
        self.movieHomeView.searchViewController.view.isHidden = true
    }
}

//MARK:- Routing
extension MovieHomeViewController {
    
    private func pushMovieDetail(with vm: MovieViewModel) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.prepareVC(vm)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
