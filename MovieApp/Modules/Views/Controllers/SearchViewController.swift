//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let vm = SearchViewModel()
    private let searchView = SearchView()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindVM()
        self.setupUI()
//        vm.prepareDatasource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm.prepareDatasource()
    }
    
    //MARK:- Bind VM
    private func bindVM() {
        self.vm.$dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (dataSource) in
                guard let weakSelf = self else { return }
                weakSelf.searchView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //MARK:- VC Setup
    private func setupUI() {
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        RecentSearchTableViewCell.registerWithTable(self.searchView.tableView)
    }
    
    override func loadView() {
        super.loadView()
        self.view = searchView
    }
}

//MARK:- TableView datasource & delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        self.pushMovieDetail(with: movieVM)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.vm.sectionTitle
    }
}

//MARK:- TableView cell config
extension SearchViewController {

    private func cellForMovie(_ vm: MovieViewModel, indexPath: IndexPath) -> RecentSearchTableViewCell {
        let cell = self.searchView.tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.reuseIdentifier, for: indexPath) as! RecentSearchTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK:- Routing
extension SearchViewController {
    
    private func pushMovieDetail(with vm: MovieViewModel) {
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.prepareVC(vm)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
