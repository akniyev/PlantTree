//
//  ChangeEmailViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class ChangeEmailViewController : FormViewController {
    var currentEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Смена email"
        form
        +++ Section("Введите адрес почты, текущий адрес: \(currentEmail)") <<< EmailRow() { row in
            row.tag = "email1"
            row.placeholder = "Введите новый email"
            row.add(rule: RuleEmail())
            row.add(rule: RuleRequired())
        } <<< EmailRow() { row in
            row.tag = "email2"
            row.placeholder = "Введите новый email еще раз"
            row.add(rule: RuleEqualsToRow(form: form, tag: "email1"))
            row.add(rule: RuleEmail())
            row.add(rule: RuleRequired())
        }
        +++ Section() <<< ButtonRow() { row in
            row.title = "Изменить"
            row.onCellSelection(self.changeEmailAction)
        }
    }
    
    func changeEmailAction(cell: ButtonCellOf<String>, row: ButtonRow) {
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
