//
//  RegistrationViewController.swift
//  PlantTree
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class RegistrationViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Регистрация"
        self.form
//            +++ Section("Данные для регистрации")
//            <<< TextRow() { row in
//                row.tag = "firstname"
//                row.placeholder = "Введите ваше имя"
//                row.add(rule: RuleRequired())
//            }
//            <<< TextRow() { row in
//                row.tag = "secondname"
//                row.placeholder = "Введите вашу фамилию"
//                row.add(rule: RuleRequired())
//            }
//            <<< SegmentedRow<String>("gender") { row in
//                row.title = "Ваш пол:"
//                row.options = ["Мужской", "Женский"]
//                row.add(rule: RuleRequired())
//            }
//            <<< DateRow() { row in
//                row.title = "Дата рождения"
//                row.tag = "birthdate"
//                row.add(rule: RuleRequired())
//            }
            +++ Section("Введите адрес почты")
            <<< EmailRow() { row in
                row.tag = "email1"
                row.placeholder = "Введите email"
                row.add(rule: RuleEmail())
                row.add(rule: RuleRequired())
            }
            <<< EmailRow() { row in
                row.tag = "email2"
                row.placeholder = "Введите email еще раз"
                row.add(rule: RuleEqualsToRow(form: form, tag: "email1"))
                row.add(rule: RuleEmail())
                row.add(rule: RuleRequired())
            }
            +++ Section("Пароль не короче 6 символов")
            <<< PasswordRow() { row in
                row.tag = "password1"
                row.placeholder = "Введите пароль"
                row.add(rule: RuleMinLength(minLength: 6))
                row.add(rule: RuleRequired())
            }
            <<< PasswordRow() { row in
                row.tag = "password2"
                row.placeholder = "Введите пароль еще раз"
                row.add(rule: RuleEqualsToRow(form: form, tag: "password1"))
                row.add(rule: RuleMinLength(minLength: 6))
                row.add(rule: RuleRequired())
            }
            +++ Section()
            <<< RoundButtonRowNew() { row in
                row.titleForButton = "Зарегистрироваться"
                row.presetGreenBackground()
                row.onCellSelection{[weak self] _,_ in
                    self?.registerAction()
                }
            }
    }
    
    func registerAction() {
        let errors = form.validate()
        
        for row in form.allRows {
            if row is RoundButtonRowNew {
                continue
            }
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
        
        if errors.count > 0 {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Неправильно заполнены поля. Пожалуйста, исправьте.", completion: nil)
        } else {
            let values = form.values()
            let email = values["email1"]  as! String
            let password = values["password1"]  as! String
//            let firstname = values["firstname"]  as! String
//            let secondname = values["secondname"]  as! String
//            let gender = (values["gender"]  as! String == "Мужской") ? Gender.Male : Gender.Female
//            let birthdate = values["birthdate"] as! Date
//            var pd = PersonalData()
//            pd.firstname = firstname
//            pd.secondname = secondname
//            pd.gender = gender
//            pd.birthdate = birthdate
            
            LoadingIndicatorView.show("Регистрация...")
            Server.RegisterWithEmail(email: email, password: password, //personalData: pd,
                                     SUCCESS: {
                                        LoadingIndicatorView.hide()
                                        Alerts.ShowAlert(sender: self, title: "Готово!", message: "Для завершения регистрации проверьте почту, мы выслали вам письмо со ссылкой для подтверждения вашего адреса", preferredStyle: .alert, actions: [UIAlertAction.init(title: "OK", style: .default, handler:
                                            { alert in
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                            )], completion: nil)
                                        },
                                     ERROR: { et, msg in
                                        LoadingIndicatorView.hide()
                                        Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка регистрации", message: msg, completion: nil)
                                        })
        }
    }
}
