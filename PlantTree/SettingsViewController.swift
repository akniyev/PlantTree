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
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowLoginScreen()
    }
    
    func ShowLoginScreen() {
        form.removeAll()
        self.navigationItem.title = "Вход"
        self.form +++ Section("Введите ваши данные")
            <<< EmailRow() { row in
                row.tag = "email"
                row.placeholder = "Enter your email"
            }
            <<< PasswordRow() { row in
                row.tag = "password"
                row.placeholder = "Enter your password"
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
        form
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
                row.title = "Ivan Ivanov"
            }
            <<< LabelRow() { row in
                row.title = "Дата рождения: 12.01.1998"
            }
            <<< ButtonRow() { row in
                row.title = "Изменить личные данные"
                row.onCellSelection(self.changePersonalDataAction)
            }
            +++ Section()
            <<< LabelRow() { row in
                row.title = "18 985р, 15 проектов"
            }
            <<< ButtonRow() { row in
                row.title = "Просмотреть историю операций"
                row.onCellSelection(self.showOperationHistoryAction)
            }
            +++ Section()
            <<< LabelRow() { row in
                row.title = "Email: a@b.ru"
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
    }
    
    func personalDataSaveAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        
    }
    
    func signInAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        ShowPersonalSettings()
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
        ShowLoginScreen()
    }
}

