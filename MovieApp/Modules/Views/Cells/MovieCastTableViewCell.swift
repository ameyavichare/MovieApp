//
//  MovieCastTableViewCell.swift
//  MovieApp
//
//  Created by Ameya on 27/04/21.
//

import UIKit

class MovieCastTableViewCell: ReusableTableViewCell {

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var vm: MovieCastListViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareCollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.vm = nil
        self.collectionView.reloadData()
    }
    
    func prepareCell(_ vm: MovieCastListViewModel) {
        self.vm = vm
        self.setupUI()
        self.collectionView.reloadData()
    }
    
    private func setupUI() {
        
        self.sectionTitle.text = self.vm?.sectionTitle
    }
    
    private func prepareCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        MovieCastCollectionViewCell.registerWithCollection(self.collectionView)
    }
    
}

extension MovieCastTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.vm == nil ? 0 : self.vm!.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCastCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCastCollectionViewCell
        if let vm = vm {
            cell.prepareCell(vm.vmAtIndex(indexPath.item))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
}
