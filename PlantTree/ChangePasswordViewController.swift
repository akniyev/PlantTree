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
        +++ Section()
        <<< PasswordRow() { row in
            row.tag = "password_old"
            row.placeholder = "Введите старый пароль"
            row.add(rule: RuleMinLength(minLength: 6))
            row.add(rule: RuleRequired())
        }
        +++ Section()
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
        <<< RoundButtonRowNew() { [weak self] row in
            row.presetGreenBackground()
            row.titleForButton = "Сменить пароль"
            row.onCellSelection{_,_ in
                self?.changePasswordAction()
            }
        }
    }
    
    func changePasswordAction() {
        let _ = form.validate()
        var haveErrors = false
        for row in form.allRows {
            if row is RoundButtonRowNew {
                continue
            }
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
                haveErrors = true
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
        
        if !haveErrors {
            let vs = form.values()
            let old_password = (vs["password_old"] as? String) ?? ""
            let new_password = (vs["password1"] as? String) ?? ""
            
            Server.changePassword(newPassword: new_password, oldPassword: old_password, SUCCESS: {
                self.navigationController?.popViewController(animated: true)
            }, ERROR: { et, msg in
                Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
            })
        }
    }

}
