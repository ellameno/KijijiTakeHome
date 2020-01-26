//
//  CategoryButton.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

class CategoryButton: UIButton {
    let VERTICAL_PADDING: CGFloat = 16
    let HORIZONTAL_PADDING: CGFloat = 20
    
    override var isHighlighted: Bool {
        didSet {
            self.updateStyleForState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 16
        self.contentEdgeInsets = UIEdgeInsets(top: VERTICAL_PADDING,
                                              left: HORIZONTAL_PADDING,
                                              bottom: VERTICAL_PADDING,
                                              right: HORIZONTAL_PADDING)
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.numberOfLines = 0 // enable multiline text
        self.titleLabel?.format(as: .body)
        self.updateStyleForState()
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = (self.titleLabel?.intrinsicContentSize ?? self.intrinsicContentSize)
        contentSize.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right
        contentSize.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel?.preferredMaxLayoutWidth = self.titleLabel?.frame.size.width ?? 0
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStyleForState() {
        if isHighlighted {
            self.backgroundColor = UIColor.systemIndigo
        } else {
            self.backgroundColor = UIColor.systemBlue
        }
    }
}
