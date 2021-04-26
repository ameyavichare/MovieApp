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
        vm.viewDidLoad()
        self.setupUI()
        self.bindVM()
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
        
        self.vm.movieChoosed.sink { [weak self] (vm) in
            guard let weakSelf = self else { return }
            print(vm.id, "movie pressed")
            weakSelf.showMovieDetail()
        }
            .store(in: &cancellables)
    }
    
    //MARK:- VC Setup
    private func setupUI() {
        self.configureTableView()
    }
    
    private func configureTableView() {
        self.movieHomeView.tableView.delegate = self
        self.movieHomeView.tableView.dataSource = self
        MovieTableViewCell.registerWithTable(self.movieHomeView.tableView)
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
        self.vm.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.vm.vmAtIndex(indexPath.row)
        return cellForMovie(vm, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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

//MARK:- Routing
extension MovieHomeViewController {
    
    private func showMovieDetail() {
        self.navigationController?.pushViewController(MovieDetailViewController(), animated: true)
    }
}
