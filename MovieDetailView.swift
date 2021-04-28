//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

///Responsible for the MovieDetailViewController view
class MovieDetailView: UIView {

    private(set) var tableView: UITableView!

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
}
