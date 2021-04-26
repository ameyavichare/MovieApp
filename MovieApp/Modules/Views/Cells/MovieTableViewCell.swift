//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import UIKit
import Kingfisher

class MovieTableViewCell: ReusableTableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var bookButton: UIButton!
    
    private var vm: MovieViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareCell(_ vm: MovieViewModel) {
        self.vm = vm
        self.setupUI()
    }
    
    private func setupUI() {
        guard let vm = vm else { return }
        self.movieName.text = vm.name
        self.movieReleaseDate.text = vm.releaseDate
        self.movieDescription.text = vm.movieDescription
        self.moviePoster.kf.setImage(with: vm.posterImageURL)
    }
    
    @IBAction func bookPressed(_ sender: UIButton) {
        self.vm?.bookPressed()
    }
}
