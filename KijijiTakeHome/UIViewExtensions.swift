//
//  UIViewExtensions.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fill(view: UIView) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func fillWithinSafeArea(view: UIView) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fillWithinMargins(view: UIView) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            self.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            self.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            self.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
