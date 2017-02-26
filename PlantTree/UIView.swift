//
//  UIView.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
