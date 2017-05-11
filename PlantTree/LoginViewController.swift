//
//  LoginViewController.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


class LoginViewController : ReloadableViewController, UITextFieldDelegate {
    @IBOutlet weak var v_Container: UIView!
    @IBOutlet weak var c_ContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tf_Email: LoginTextField!
    @IBOutlet weak var tf_Password: LoginTextField!
    @IBOutlet weak var btn_Register: UIButton!
    @IBOutlet weak var btn_ForgotPassword: UIButton!
    @IBOutlet weak var btn_Enter: RoundBorderButton!
    @IBOutlet weak var btn_Facebook: RoundBorderButton!

    private var keyboardRect: CGRect = CGRect()

    // <Actions>
    @IBAction func touch_RegisterButton(_ sender: Any) {
    }
    @IBAction func touch_ForgotPassword(_ sender: Any) {
    }
    @IBAction func touch_Enter(_ sender: Any) {
        self.tf_Password.resignFirstResponder()
        self.tf_Email.resignFirstResponder()

        let email = self.tf_Email.text ?? ""
        let password = self.tf_Password.text ?? ""

        print(email)
        print(password)
        if checkInput() {
            LoadingIndicatorView.show()
            Server.SignInWithEmail(email: email, password: password, SUCCESS: { [weak self] cred in
                self?.performSegue(withIdentifier: "LOGIN", sender: self)
                LoadingIndicatorView.hide()
            }, ERROR: { [weak self] et, msg in
                if let s = self {
                    Alerts.ShowErrorAlertWithOK(sender: s, title: "Ошибка", message: "Проверьте правильность введеных реквизитов, а также подключение к сети.", completion: nil)
                }
                LoadingIndicatorView.hide()
            })
        } else {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Введены некорректные email/пароль", completion: nil)
        }
    }
    @IBAction func touch_Facebook(_ sender: Any) {
    }
    // </Actions>

    func checkInput() -> Bool {
        if let email = self.tf_Email.text, let password = self.tf_Password.text {
            return email.characters.count > 3 && password.characters.count > 0
        } else {
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        btn_Facebook.addTarget(self, action: #selector(self.facebookButtonClicked), for: .touchUpInside)

        self.navigationItem.title = "Аккаунт"
        tf_Email.delegate = self
        tf_Password.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.dismissKeyboard))

        self.v_Container.addGestureRecognizer(tap)

        if Db.isAuthorized() {
            self.performSegue(withIdentifier: "LOGIN_WITHOUT_ANIMATION", sender: self)
        }
    }

    func facebookButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self, completion: { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                if let s = self {
                    Alerts.ShowErrorAlertWithOK(sender: s, title: "Ошибка", message: "Произошла ошибка при попытке войти в аккаунт (\(error.localizedDescription))", completion: nil)
                }
            case .cancelled:
                break
            case .success(let grantedPermissions, let declinedPermissions, let facebookToken):
                Server.SignInWithFacebook(
                    facebookToken: facebookToken.authenticationToken,
                    SUCCESS: { c in
                        if let s = self {
                            s.performSegue(withIdentifier: "LOGIN_WITHOUT_ANIMATION", sender: s)
                        }
                    },
                    ERROR: { et, msg in
                        if let s = self {
                            Alerts.ShowErrorAlertWithOK(sender: s, title: "Ошибка", message: "Не удалось зайти через Facebook", completion: nil)
                        }
                    })
            }
        })
    }

    func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardRect = keyboardFrame
        self.setContraintForLoginFields()
    }

    func keyboardHidden(notification: NSNotification) {
        self.setContraintForLoginFields(reset: true)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tf_Email {
            self.tf_Password.becomeFirstResponder()
        } else {
            self.tf_Password.resignFirstResponder()
        }
        return true
    }


    func dismissKeyboard() {
        self.tf_Email.resignFirstResponder()
        self.tf_Password.resignFirstResponder()
    }

    func setContraintForLoginFields(reset: Bool = false) {
        var newConstant: CGFloat = 0
        if !reset {
            let f = self.view.convert(self.btn_Enter.frame, from: self.v_Container)
            let a = f.origin.y + f.height - self.c_ContainerTopConstraint.constant
            if self.keyboardRect.origin.y < a + 10 {
                let diff = a + 10 - self.keyboardRect.origin.y
                print(diff)
                newConstant = -diff
            }
        }

        self.c_ContainerTopConstraint.constant = newConstant
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

}
