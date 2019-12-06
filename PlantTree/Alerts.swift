//
//  Alerts.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

//
// Created by Admin on 04/12/2016.
// Copyright (c) 2016 greenworld. All rights reserved.
//

import UIKit

class Alerts {
    static func ShowAlert(
        sender : UIViewController,
        title : String,
        message : String,
        preferredStyle : UIAlertController.Style,
        actions : [UIAlertAction],
        completion : (() -> ())?) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for a in actions {
            alert.addAction(a)
        }
        sender.present(alert, animated: true, completion: completion)
    }
    
    static func ShowErrorAlertWithOK(
        sender : UIViewController,
        title : String,
        message : String,
        completion : (() -> ())?) {
        ShowAlert(
            sender: sender,
            title: title,
            message: message,
            preferredStyle: .alert,
            actions: [UIAlertAction(title: "OK", style: .default)],
            completion: completion)
    }
    
    static func ShowActionSheet(
        sender : UIViewController,
        title: String,
        items : [String],
        callback : ((Int) -> ())?,
        completion : (() -> ())?) {
        let actionSheet: UIAlertController = UIAlertController(
            title: nil,
            message: title,
            preferredStyle: .actionSheet)
        for i in 0..<items.count {
            actionSheet.addAction(UIAlertAction(title: items[i], style: .default, handler: { a in
                callback?(i)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
        sender.present(actionSheet, animated: true, completion: completion)
    }
}


