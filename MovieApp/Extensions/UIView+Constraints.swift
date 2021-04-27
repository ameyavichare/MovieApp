//
//  UIView+Constraints.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import UIKit

extension UIView {

    func constrainToEdges(_ subview: UIView, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leadingConstant: CGFloat = 0, trailingContraint: CGFloat = 0) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .topMargin,
            multiplier: 1.0,
            constant: topConstant
        )

        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottomMargin,
            multiplier: 1.0,
            constant: bottomConstant
        )

        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: leadingConstant
        )

        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: trailingContraint
        )

        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint,
        ])
    }
}
