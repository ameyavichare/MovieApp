//
//  UICollectionView+Additions.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import UIKit

open class ReusableCollectionViewCell: UICollectionViewCell {
    
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    public static func registerWithCollection(_ collectionView: UICollectionView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}
