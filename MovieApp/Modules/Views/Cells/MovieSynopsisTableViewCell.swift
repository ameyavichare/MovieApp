//
//  MovieSynopsisTableViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class MovieSynopsisTableViewCell: ReusableTableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieVoteCount: UILabel!
    
    private var vm: MovieSynopsisViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(_ vm: MovieSynopsisViewModel) {
        self.vm = vm
        self.setupUI()
    }
    
    private func setupUI() {
        guard let vm = vm else { return }
        self.movieName.text = vm.name
        self.movieGenres.text = vm.genres
        self.movieDescription.text = vm.movieDescription
        self.movieVoteAverage.text = vm.voteAverage
        self.movieVoteCount.text = vm.voteCount
        self.moviePoster.kf.setImage(with: vm.posterImageURL)
    }
}
