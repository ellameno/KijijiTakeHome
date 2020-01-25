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
        self.tagButton.setTitle(category.name, for: .normal)
    }
    
    lazy var tagButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(tagButton)
        tagButton.fill(view: contentView)
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
