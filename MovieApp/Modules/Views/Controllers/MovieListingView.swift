//
//  MovieListingView.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import UIKit

class MovieHomeView: UIView {
    
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
        self.tableView.backgroundColor = .red
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.addSubview(self.tableView)
        self.constrainToEdges(tableView)
    }
}
