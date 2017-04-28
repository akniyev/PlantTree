//
//  LoginViewController.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var tf_Login: LoginTextField!
    @IBOutlet weak var tf_Password: LoginTextField!
    @IBOutlet weak var btn_Register: UIButton!
    @IBOutlet weak var btn_ForgotPassword: UIButton!
    @IBOutlet weak var btn_Login: RoundBorderButton!
    @IBOutlet weak var btn_FacebookLogin: FacebookButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = "Аккаунт"
        
        tf_Login.setImage(img: UIImage(named: "login_screen_mail"))
        tf_Password.setImage(img: UIImage(named: "login_screen_lock"))
        
        tf_Login.setPlaceholderText(text: "Введите ваш email")
        tf_Password.setPlaceholderText(text: "Введите ваш пароль")
        
        self.view.frame.origin = CGPoint(x: 0, y: 500)
    }
}
