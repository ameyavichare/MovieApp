//
//  RecentSearchTableViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class RecentSearchTableViewCell: ReusableTableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    private var vm: MovieViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareCell(_ vm: MovieViewModel) {
        self.vm = vm
        self.setupUI()
        self.populateData()
    }
    
    private func setupUI() {
        self.moviePoster.contentMode = .scaleAspectFill
    }
    
    private func populateData() {
        guard let vm = vm else { return }
        self.movieName.text = vm.name
        self.moviePoster.kf.setImage(with: vm.posterImageURL)
    }
}
