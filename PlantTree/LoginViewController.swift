//
//  LoginViewController.swift
//  PlantTree
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class LoginViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func signInAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        print("Signed in!!!!")
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
}
