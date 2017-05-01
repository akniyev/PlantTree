//
//  ProfileViewController.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProfileViewController : UIViewController {
    @IBOutlet weak var img_ProfilePicture: RoundImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_TreeCount: UILabel!
    @IBOutlet weak var lbl_Donated: UILabel!
    @IBOutlet weak var lbl_ConfirmEmail: UILabel!
    @IBOutlet weak var btn_ConfirmEmail: UIButton!
    @IBOutlet weak var btn_EditProfile: UIButton!
    @IBOutlet weak var btn_OperationHistory: RoundBorderButton!
    @IBOutlet weak var btn_LogOut: RoundBorderButton!
    
    //<Actions>
    @IBAction func tap_EditProfile(_ sender: Any) {
    }
    
    @IBAction func tap_OperationHistory(_ sender: Any) {
    }
    
    @IBAction func tap_LogOut(_ sender: Any) {
        Alerts.ShowAlert(sender: self, title: "Подтверждение", message: "Вы действительно хотите выйти из аккаунта?", preferredStyle: .alert, actions:
                [UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
                    Server.SignOut()
                    self?.navigationController?.popViewController(animated: true)
                }),
                 UIAlertAction(title: "Нет", style: .default)], completion: nil)
    }
    
    @IBAction func tap_ConfirmEmail(_ sender: Any) {
    }
    //</Actions>

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Аккаунт"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }



}
