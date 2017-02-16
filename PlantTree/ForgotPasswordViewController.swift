//
//  ForgotPasswordViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class ForgotPasswordViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Сброс пароля"
        self.form +++ Section("Введите адрес вашей почты, чтобы мы выслали ссылку для сброса пароля")
            <<< EmailRow() { row in
                row.placeholder = "Введите адрес почты"
                row.tag = "email"
                row.add(rule: RuleEmail())
                row.add(rule: RuleRequired())
            }
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "Сбросить пароль"
                row.onCellSelection(self.resetPasswordAction)
            }
    }
    
    func resetPasswordAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        form.validate()
        let errors = form.validate()
        
        for row in form.allRows {
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
        
        if errors.count > 0 {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Введен некорректный адрес почты!", completion: nil)
        } else {
            let email = form.values()["email"] as! String
            print(email)
        }
    }
}
