//
//  UIColorExtensions.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-26.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var highlightBackground: UIColor {
        return UIColor.white.withDarkModeOption(UIColor.systemGray3)
    }
    static var backgroundMain: UIColor {
        return UIColor.systemGray6
    }
    func withDarkModeOption(_ darkModeColor: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkModeColor
                } else {
                    return self
                }
            }
        } else {
            return darkModeColor
        }
    }
}
