//
//  MovieReviewCollectionViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class MovieReviewCollectionViewCell: ReusableCollectionViewCell {

    private var vm: MovieReviewViewModel?
    @IBOutlet weak var reviewAuthor: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vm = nil
    }
    
    func prepareCell(_ vm: MovieReviewViewModel?) {
        guard let vm = vm else { return }
        self.vm = vm
        self.setupUI()
        self.populateData()
    }
    
    private func setupUI() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    private func populateData() {
        guard let vm = vm else { return }
        self.reviewAuthor.text = vm.author
        self.reviewContent.text = vm.content
    }

}
