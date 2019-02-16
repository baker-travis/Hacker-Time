//
//  UIViewController+showAlert.swift
//  Hacker Time
//
//  Created by Travis Baker on 2/15/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showNetworkError(message: String) {
        showAlert(title: "Network Error", message: message)
    }
}
