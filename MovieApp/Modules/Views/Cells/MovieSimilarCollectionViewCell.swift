//
//  MovieSimilarCollectionViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class MovieSimilarCollectionViewCell: ReusableCollectionViewCell {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    private var vm: MovieViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func prepareCell(_ vm: MovieViewModel?) {
        guard let vm = vm else { return }
        self.vm = vm
        self.setupUI()
        self.populateData()
    }
    
    private func setupUI() {
        self.moviePoster.contentMode = .scaleAspectFill
        self.moviePoster.layer.cornerRadius = 10
        self.moviePoster.clipsToBounds = true
    }
    
    private func populateData() {
        guard let vm = vm else { return }
        self.movieName.text = vm.name
        self.moviePoster.kf.setImage(with: vm.posterImageURL)
    }
}
