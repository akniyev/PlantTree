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
import Kingfisher

class SettingsViewController : FormViewController {
    var loginSections : [Section] = []
    var settingsSections : [Section] = []
    var downloadFailedSections : [Section] = []
    
    var personalData : PersonalData? = nil
    var email : String = ""
//    var photoView : ImageView? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        reloadPersonalSettingsForm()
    }

    func CreateForm() {
        let loginSection01 = Section("Введите ваши данные") <<< EmailRow() { row in
            row.tag = "login_email"
            row.placeholder = "Enter your email"
            row.add(rule: RuleEmail())
            row.add(rule: RuleRequired())
        } <<< PasswordRow() { row in
            row.tag = "login_password"
            row.placeholder = "Enter your password"
            row.add(rule: RuleRequired())
        } <<< ButtonRow() { row in
            row.title = "Войти"
            row.onCellSelection(self.signInAction)
        }
//        let loginSection02 = Section() <<< ButtonRow() { row in
//            row.title = "Войти через Facebook"
//            row.onCellSelection(self.facebookSignInAction)
//        }
        let loginSection03 = Section() <<< ButtonRow() { row in
            row.title = "Регистрация"
            row.onCellSelection(self.registrationAction)
        } <<< ButtonRow() { row in
            row.title = "Забыли пароль?"
            row.onCellSelection(self.forgotPasswordAction)
        }
        loginSections = [loginSection01,
                         //loginSection02,
                         loginSection03]
        self.form +++ loginSection01
            //+++ loginSection02
            +++ loginSection03

        let settingsSection01 = Section("Персональные данные") <<< UserInfoRow() { row in
            row.tag = "userInfo"
        } <<< ButtonRow() { row in
            row.title = "Изменить личные данные"
            row.onCellSelection(self.changePersonalDataAction)
        }
        let settingsSection02 = Section() <<< LabelRow() { row in
            row.tag = "projectCount"
            row.title = "-р, - проектов"
        } <<< ButtonRow() { row in
            row.title = "Просмотреть историю операций"
            row.onCellSelection(self.showOperationHistoryAction)
        }
        let settingsSection03 = Section() <<< LabelRow() { row in
            row.tag = "settings_email"
            row.title = "Email: -"
        }
//            <<< ButtonRow() { row in
//            row.title = "Изменить email"
//            row.onCellSelection(self.changeEmailAction)
//        }
        <<< ButtonRow() { row in
            row.title = "Сменить пароль"
            row.onCellSelection(self.changePasswordAction)
        }
        let settingsSection04 = Section("Вы не подтвердили свой email") <<< ButtonRow() { row in
            row.title = "Подтвердить email"
            row.onCellSelection(self.confirmEmailAction)
        }
        settingsSection04.tag = "confirmEmail"
        let settingsSection05 = Section() <<< ButtonRow() { row in
            row.title = "Выход"
            row.onCellSelection(self.signOutAction)
        }
        settingsSections = [settingsSection01, settingsSection02, settingsSection03,
        settingsSection04, settingsSection05]
        self.form +++ settingsSection01 +++ settingsSection02 +++ settingsSection03
            +++ settingsSection04 +++ settingsSection05
        
        let downloadFailedSections01 = Section("Не удалось загрузить данные с сервера") <<< ButtonRow() { row in
            row.title = "Повторить"
            row.onCellSelection(self.reloadPersonalDataAction)
        }
        downloadFailedSections = [downloadFailedSections01]
        self.form +++ downloadFailedSections01
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        CreateForm()
    }

    func ShowLoginScreen() {
        self.navigationItem.title = "Вход"
        for s in loginSections {
            s.hidden = false
            s.evaluateHidden()
        }
        for s in settingsSections {
            s.hidden = true
            s.evaluateHidden()
        }
        for s in downloadFailedSections {
            s.hidden = true
            s.evaluateHidden()
        }
    }
    
    func HideAllForms() {
        for s in form.allSections {
            s.hidden = true
            s.evaluateHidden()
        }
    }
    
    func ShowDownloadFailedButton() {
        for s in loginSections {
            s.hidden = true
            s.evaluateHidden()
        }
        for s in settingsSections {
            s.hidden = true
            s.evaluateHidden()
        }
        for s in downloadFailedSections {
            s.hidden = false
            s.evaluateHidden()
        }
    }
    
    func SetPersonalData(pd: PersonalData) {
        (self.form.rowBy(tag: "userInfo") as! UserInfoRow).value = pd
        (self.form.rowBy(tag: "userInfo") as! UserInfoRow).reload()
        
        self.form.rowBy(tag: "projectCount")?.title = "\(pd.moneyDonated)р, \(pd.donatedProjectCount) проектах"
        self.form.rowBy(tag: "projectCount")?.reload()
        
        self.form.rowBy(tag: "settings_email")?.title = "Email: \(pd.email)"
        self.form.rowBy(tag: "settings_email")?.reload()
        
        self.form.sectionBy(tag: "confirmEmail")?.hidden = pd.email_confirmed ? true : false
        self.form.sectionBy(tag: "confirmEmail")?.evaluateHidden()
    }

    func ShowPersonalSettings() {
        self.navigationItem.title = "Аккаунт"
        for s in loginSections {
            s.hidden = true
            s.evaluateHidden()
        }
        for s in settingsSections {
            s.hidden = false
            s.evaluateHidden()
        }
        for s in downloadFailedSections {
            s.hidden = true
            s.evaluateHidden()
        }
    }

    func personalDataSaveAction(cell: ButtonCellOf<String>, row: ButtonRow) {

    }
    
    func reloadPersonalSettingsForm() {
        if Db.isAuthorized() {
            LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
            if personalData == nil {
                HideAllForms()
            }
            Server.GetAccountInfo(SUCCESS: { pd in
                self.ShowPersonalSettings()
                self.SetPersonalData(pd: pd)
                self.personalData = pd
                LoadingIndicatorView.hide()
            }, ERROR: { et, msg in
                if et == ErrorType.Unauthorized {
                    Server.SignOut()
                    self.ShowLoginScreen()
                } else {
                    self.ShowDownloadFailedButton()
                }
                LoadingIndicatorView.hide()
            })
        } else {
            ShowLoginScreen()
        }
    }
    
    func reloadPersonalDataAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        reloadPersonalSettingsForm()
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
            let email = values["login_email"] as! String
            let password = values["login_password"] as! String

            Server.SignInWithEmail(
                    email: email,
                    password: password,
                    SUCCESS: { c in
                        (self.form.rowBy(tag: "login_password") as? PasswordRow)?.value = ""
                        if Db.writeCredentials(c: c) {
                            self.ShowPersonalSettings()
                            self.reloadPersonalSettingsForm()
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

//    func changeEmailAction(cell: ButtonCellOf<String>, row: ButtonRow) {
//        self.performSegue(withIdentifier: "openChangeEmail", sender: self)
//    }

    func changePasswordAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        self.performSegue(withIdentifier: "openChangePassword", sender: self)
    }

    func confirmEmailAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        Server.confirmEmail(SUCCESS: {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Отправлено", message: "Ссылка для подтверждения почты отправлена вам на почту.", completion: nil)
        }, ERROR: { et, msg in
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
        })
    }

    func signOutAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        Db.writeCredentials(c: nil)
        ShowLoginScreen()
    }

    override func prepare(`for` segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let vc = segue.destination
        if vc is ChangePersonalDataViewController {
            (vc as! ChangePersonalDataViewController).pd = personalData
        } else if vc is ChangeEmailViewController {
            (vc as! ChangeEmailViewController).currentEmail = personalData?.email ?? ""
        }
    }

}

