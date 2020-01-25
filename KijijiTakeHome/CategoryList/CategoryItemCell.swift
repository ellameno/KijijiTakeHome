//
//  CategoryItemCell.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryItemCellDelegate: class {
    func didSelectCategory(_ category: Category)
}
class CategoryItemCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryItemCell"
    private var category: Category?
    weak var delegate: CategoryItemCellDelegate?
    
    func configure(with category: Category) {
        self.category = category
        let buttonTitle = "\(category.name) (\(category.count))"
        self.tagButton.setTitle(buttonTitle, for: .normal)
    }
    
    lazy var tagButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagButton)
        NSLayoutConstraint.activate([
            tagButton.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            tagButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            tagButton.rightAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.rightAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        tagButton.addTarget(self, action: #selector(onPressCategoryButton(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onPressCategoryButton(_: UIButton) {
        guard let category = self.category else {
            log.error("No category set")
            return
        }
        delegate?.didSelectCategory(category)
    }
}
