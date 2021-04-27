//
//  MovieCastCollectionViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class MovieCastCollectionViewCell: ReusableCollectionViewCell {

    @IBOutlet weak var castProfileImage: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var castCharacter: UILabel!
    
    private var vm: MovieCastViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareCell(_ vm: MovieCastViewModel?) {
        guard let vm = vm else { return }
        self.vm = vm
        self.setupUI()
        self.populateData()
    }
    
    private func setupUI() {
        self.castProfileImage.backgroundColor = .systemGray5
        self.castProfileImage.contentMode = .scaleAspectFill
        self.castProfileImage.layer.cornerRadius = self.castProfileImage.bounds.height/2
        self.castProfileImage.clipsToBounds = true
    }
    
    private func populateData() {
        guard let vm = vm else { return }
        self.castName.text = vm.name
        self.castCharacter.text = vm.character
        self.castProfileImage.kf.setImage(with: vm.profileImageURL)
    }

}
