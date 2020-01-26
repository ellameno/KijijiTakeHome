//
//  UILabelExtensions.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-26.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func format(as style: TypographyStyle) {
        
        // Enable font-scaling
        self.adjustsFontForContentSizeCategory = true
            let fontMetrics = UIFontMetrics(forTextStyle: style.textStyle)
        self.font = fontMetrics.scaledFont(for: style.font)
    }
}
