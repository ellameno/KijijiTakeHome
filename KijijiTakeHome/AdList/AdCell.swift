//
//  AdCell.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

class AdCell: UICollectionViewCell {
    static let reuseIdentifier = "AdCell"
    private var advertisement: Advertisement?
    
    func configure(with advertisement: Advertisement) {
        self.advertisement = advertisement
        self.titleLabel.text = advertisement.title
    }
    
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.fill(view: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
