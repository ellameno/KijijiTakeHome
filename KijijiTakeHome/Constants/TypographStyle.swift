//
//  TypographStyle.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-26.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

enum TypographyStyle {
    case body, strong, h1, h2
    
    var font: UIFont {
        switch self {
        case .body:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .strong:
            return UIFont.systemFont(ofSize: 15, weight: .bold)
        case .h1:
            return UIFont.systemFont(ofSize: 28, weight: .regular)
        case .h2:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        }
    }
    
    var textStyle: UIFont.TextStyle {
        switch self {
        case .body:
            return .body
        case .strong:
            return .caption1
        case .h1:
            return .title1
        case .h2:
            return .title2
        }
    }
}
