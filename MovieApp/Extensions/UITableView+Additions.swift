//
//  UITableView+Additions.swift
//  MovieApp
//
//  Created by Ameya on 26/04/21.
//

import Foundation
import UIKit

open class ReusableTableViewCell: UITableViewCell {
    
    public class var reuseIdentifier: String {
        return "\(self.self)"
    }
    
    public static func registerWithTable(_ tableView: UITableView) {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: self.reuseIdentifier, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: self.reuseIdentifier)
    }
}
