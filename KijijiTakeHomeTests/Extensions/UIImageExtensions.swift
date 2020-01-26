//
//  UIImage+Helper.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-26.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
