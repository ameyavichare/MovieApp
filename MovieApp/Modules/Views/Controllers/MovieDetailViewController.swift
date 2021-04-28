//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    //MARK:- Properties
    private var vm: MovieDetailViewModel! ///View Model
    private var movieDetailView = MovieDetailView() ///View
    private var cancellables: Set<AnyCancellable> = [] ///Used for storing the

    //MARK:- Overriding Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindVM()
        self.setupUI()
        self.vm.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = movieDetailView
    }
    
    //MARK:- Prepare VC
    ///Data from previous VC
    func prepareVC(_ vm: MovieViewModel) {
        self.vm = MovieDetailViewModel(vm.id)
    }
    
    //MARK:- Bind VM
    private func bindVM() {
        ///When the dataSource in VM changes, reload the tableView
        self.vm.$dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (dataSource) in
                guard let weakSelf = self else { return }
                weakSelf.movieDetailView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    //MARK:- VC Setup
    private func setupUI() {
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.movieDetailView.tableView.delegate = self
        self.movieDetailView.tableView.dataSource = self
        MovieSynopsisTableViewCell.registerWithTable(self.movieDetailView.tableView)
        MovieReviewTableViewCell.registerWithTable(self.movieDetailView.tableView)
        MovieCastTableViewCell.registerWithTable(self.movieDetailView.tableView)
        MovieSimilarTableViewCell.registerWithTable(self.movieDetailView.tableView)
    }
}

//MARK:- TableView datasource & delegate
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.vm.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.vm.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.vm.cellTypeForIndex(indexPath.row)
        switch cellType {
            case .synopsisCell(let vm):
                return cellForSynopsisCell(vm, indexPath: indexPath)
            case .reviewCell(let vm):
                return cellForReviewCell(vm, indexPath: indexPath)
            case .castCell(let vm):
                return cellForCastCell(vm, indexPath: indexPath)
            case .similarCell(let vm):
                return cellForSimilarCell(vm, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//MARK:- TableView cell config
extension MovieDetailViewController {

    private func cellForSynopsisCell(_ vm: MovieSynopsisViewModel, indexPath: IndexPath) -> MovieSynopsisTableViewCell {
        let cell = self.movieDetailView.tableView.dequeueReusableCell(withIdentifier: MovieSynopsisTableViewCell.reuseIdentifier, for: indexPath) as! MovieSynopsisTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
    
    private func cellForReviewCell(_ vm: MovieReviewListViewModel, indexPath: IndexPath) -> MovieReviewTableViewCell {
        let cell = self.movieDetailView.tableView.dequeueReusableCell(withIdentifier: MovieReviewTableViewCell.reuseIdentifier, for: indexPath) as! MovieReviewTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
    
    private func cellForCastCell(_ vm: MovieCastListViewModel, indexPath: IndexPath) -> MovieCastTableViewCell {
        let cell = self.movieDetailView.tableView.dequeueReusableCell(withIdentifier: MovieCastTableViewCell.reuseIdentifier, for: indexPath) as! MovieCastTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
    
    private func cellForSimilarCell(_ vm: MovieSimilarListViewModel, indexPath: IndexPath) -> MovieSimilarTableViewCell {
        let cell = self.movieDetailView.tableView.dequeueReusableCell(withIdentifier: MovieSimilarTableViewCell.reuseIdentifier, for: indexPath) as! MovieSimilarTableViewCell
        cell.prepareCell(vm)
        cell.selectionStyle = .none
        return cell
    }
}
