//
//  SettingsViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class SettingsViewController : FormViewController {
    override func viewWillAppear(_ animated: Bool) {
        if Db.isAuthorized() {
            ShowPersonalSettings()
        } else {
            ShowLoginScreen()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func ShowLoginScreen() {
        form.removeAll()
        self.navigationItem.title = "Вход"
        self.form +++ Section("Введите ваши данные")
            <<< EmailRow() { row in
                row.tag = "email"
                row.placeholder = "Enter your email"
                row.add(rule: RuleEmail())
                row.add(rule: RuleRequired())
            }
            <<< PasswordRow() { row in
                row.tag = "password"
                row.placeholder = "Enter your password"
                row.add(rule: RuleRequired())
            }
            <<< ButtonRow() { row in
                row.title = "Войти"
                row.onCellSelection(self.signInAction)
            }
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "Войти через Facebook"
                row.onCellSelection(self.facebookSignInAction)
            }
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "Регистрация"
                row.onCellSelection(self.registrationAction)
            }
            <<< ButtonRow() { row in
                row.title = "Забыли пароль?"
                row.onCellSelection(self.forgotPasswordAction)
        }
    }

    func ShowPersonalSettings() {
        self.navigationItem.title = "Аккаунт"
        form.removeAll()
        Server.GetAccountInfo(SUCCESS: { pd in
            let c = Db.readCredentials()!

            self.form
                    +++ Section("Персональные данные")
                    <<< ImageRow() { row in
                                        row.title = "Ваша фотография:"
                                        row.sourceTypes = [.PhotoLibrary, .Camera, .SavedPhotosAlbum]
                                        row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                                   }.cellUpdate { cell, row in
                                                    cell.accessoryView?.layer.cornerRadius = 17
                                                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                                                }
                    <<< LabelRow() { row in
                        row.title = "\(pd.firstname) \(pd.secondname)"
                                   }
                    <<< LabelRow() { row in
                                        row.title = "Дата рождения: \(pd.birthdate?.toRussianFormat() ?? "" )"
                                   }
                    <<< ButtonRow() { row in
                                        row.title = "Изменить личные данные"
                                        row.onCellSelection(self.changePersonalDataAction)
                                    }
                    +++ Section()

                        <<< LabelRow() { row in
                    row.title = "\(pd.moneyDonated)р, \(pd.donatedProjectCount) проектов"
                }
                        <<< ButtonRow() { row in
                    row.title = "Просмотреть историю операций"
                    row.onCellSelection(self.showOperationHistoryAction)
                }
                        +++ Section()
                        <<< LabelRow() { row in
                    row.title = "Email: \(pd.email)"
                }
                        <<< ButtonRow() { row in
                    row.title = "Изменить email"
                    row.onCellSelection(self.changeEmailAction)
                }
                    <<< ButtonRow() { row in
                row.title = "Сменить пароль"
                row.onCellSelection(self.changePasswordAction)
            }
                    +++ Section()
                    <<< ButtonRow() { row in
                row.title = "Подтвердить email"
            }
                    +++ Section()
                    <<< ButtonRow() { row in
                row.title = "Выход"
                row.onCellSelection(self.signOutAction)
            }
        }, ERROR: { et, msg in
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
        })
    }

    func personalDataSaveAction(cell: ButtonCellOf<String>, row: ButtonRow) {

    }

    func signInAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        let errors = form.validate()

        for row in form.allRows {
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }

        if errors.count > 0 {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Проверьте введенные данные!", completion: nil)
        } else {
            let values = form.values()
            let email = values["email"] as! String
            let password = values["password"] as! String

            Server.SignInWithEmail(
                    email: email,
                    password: password,
                    SUCCESS: { c in
                        if Db.writeCredentials(c: c) {
                            self.ShowPersonalSettings()
                        } else {
                            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Ошибка базы данных!", completion: nil)
                        }
                    },
                    ERROR: { et, msg in
                        Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
                    })
        }
    }

    func registrationAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openRegistration", sender: self)
    }

    func forgotPasswordAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openForgotPassword", sender: self)
    }

    func facebookSignInAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        print("Signed in!!!!")
    }

    ///////////////
    func changePersonalDataAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openPersonalData", sender: self)
    }

    func showOperationHistoryAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openOperationHistory", sender: self)
    }

    func changeEmailAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openChangeEmail", sender: self)
    }

    func changePasswordAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openChangePassword", sender: self)
    }

    func confirmEmailAction(cell: ButtonCellOf<String>, row: ButtonRow) {

    }

    func signOutAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        Db.writeCredentials(c: nil)
        ShowLoginScreen()
    }
}

