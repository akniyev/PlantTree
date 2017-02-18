//
//  ChangePasswordViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class ChangePasswordViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Смена пароля"
        form
            +++ Section("Введите адрес почты")
            <<< PasswordRow() { row in
                row.tag = "password_old"
                row.placeholder = "Введите старый пароль"
                row.add(rule: RuleMinLength(minLength: 6))
                row.add(rule: RuleRequired())
            }
            <<< PasswordRow() { row in
                row.tag = "password1"
                row.placeholder = "Введите новый пароль"
                row.add(rule: RuleMinLength(minLength: 6))
                row.add(rule: RuleRequired())
            }
            <<< PasswordRow() { row in
                row.tag = "password2"
                row.placeholder = "Введите новый пароль еще раз"
                row.add(rule: RuleEqualsToRow(form: form, tag: "password1"))
                row.add(rule: RuleMinLength(minLength: 6))
                row.add(rule: RuleRequired())
            }
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "Изменить"
                row.onCellSelection(self.changePasswordAction)
            }
    }
    
    func changePasswordAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        let errors = form.validate()
        
        for row in form.allRows {
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
    }

}
