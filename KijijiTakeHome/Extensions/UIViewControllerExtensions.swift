//
//  UIViewControllerExtensions.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-26.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(message: String?) {
        let alert = UIAlertController(title: Strings.errorAlertTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.okButtonTitle, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
