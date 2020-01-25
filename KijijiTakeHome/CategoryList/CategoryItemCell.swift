//
//  CategoryItemCell.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit


class CategoryItemCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryItemCell"
    private var category: Category?
    
    func configure(with category: Category) {
        self.category = category
        self.titleLabel.text = category.name
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
