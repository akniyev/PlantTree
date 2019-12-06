//
//  ProfileViewController.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser

class ProfileViewController : ReloadableViewController {
    @IBOutlet weak var img_ProfilePicture: RoundImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_ProjectsCount: UILabel!
    @IBOutlet weak var lbl_Donated: UILabel!
    @IBOutlet weak var lbl_ConfirmEmail: UILabel!
    @IBOutlet weak var btn_ConfirmEmail: UIButton!
    @IBOutlet weak var btn_EditProfile: UIButton!
    @IBOutlet weak var btn_OperationHistory: RoundBorderButton!
    @IBOutlet weak var btn_LogOut: RoundBorderButton!
    @IBOutlet weak var stack_Container: UIStackView!
    @IBOutlet weak var lbl_ProjectsTitle: UILabel!
    @IBOutlet weak var stack_ConfirmEmail: UIStackView!
    @IBOutlet weak var lbl_Email: UILabel!

    var personalData : PersonalData? = nil
    
    //<Actions>
    @IBAction func tap_EditProfile(_ sender: Any) {
    }
    
    @IBAction func tap_OperationHistory(_ sender: Any) {
        if let vc = PaymentHistoryViewController.storyboardInstance() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        Alerts.ShowAlert(sender: self,
                title: "Подтверждение",
                message: "Вы действительно хотите заново выслать письмо для подтверждения email?",
                preferredStyle: .alert,
                actions: [
                    UIAlertAction(title: "Да", style: .default, handler: { [weak self] action in
                        if self == nil {
                            return
                        }
                        LoadingIndicatorView.show(self!.view, loadingText: "Отправка...")
                        Server.confirmEmail(SUCCESS: {
                            LoadingIndicatorView.hide()
                            Alerts.ShowErrorAlertWithOK(sender: self!, title: "Готово", message: "Сообщение со ссылкой для подтверждения email успешно отправлено. Проверье вашу почту!", completion: nil)
                        }, ERROR: { et, msg in
                            Alerts.ShowErrorAlertWithOK(sender: self!, title: "Ошибка", message: "Произошла ошибка во время отправки письма", completion: nil)
                            LoadingIndicatorView.hide()
                        })
                    }),
                    UIAlertAction(title: "Нет", style: .default, handler: nil)
                ],
                completion: nil)
    }
    //</Actions>

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Аккаунт"
        self.navigationItem.setHidesBackButton(true, animated: true)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.openBigPhoto))

        self.img_ProfilePicture.addGestureRecognizer(tap)
    }

    @objc func openBigPhoto() {
        if let pd = self.personalData {
            let photo = SKPhoto.photoWithImageURL(pd.photoUrl)
            photo.shouldCachePhotoURLImage = true
            let images = [photo]
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            self.present(browser, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadAction()
    }

    override func reloadAction() {
        self.hideReloadView()
        self.stack_Container.isHidden = true
        LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        Server.GetAccountInfo(SUCCESS: { [weak self] pi in
            let cred = Db.readCredentials()!
            LoadingIndicatorView.hide()
            self?.personalData = pi

            self?.lbl_Name.text = "\(pi.firstname) \(pi.secondname)"
            self?.lbl_Donated.text = "\(pi.moneyDonated)р."
            self?.lbl_ProjectsCount.text = "\(pi.donatedProjectCount)"
            self?.lbl_ProjectsTitle.text = pi.donatedProjectCount.getRussianCountWord(one: "Проект", tofour: "Проекта", overfour: "Проектов")
            self?.stack_Container.isHidden = false
            self?.lbl_Email.text = pi.email
            self?.stack_ConfirmEmail.isHidden = pi.email_confirmed || cred.loginType != .Email
            self?.img_ProfilePicture.isUserInteractionEnabled = true

            if !pi.photoUrlSmall.isEmpty {
                let url = URL(string: pi.photoUrlSmall)
                self?.img_ProfilePicture.kf.indicatorType = .activity
                self?.img_ProfilePicture.kf.setImage(with: url, placeholder: UIImage(named: "NoImage"), options: nil, progressBlock: nil, completionHandler: { x in })
            } else {
                self?.img_ProfilePicture.image = UIImage(named: "NoImage")
            }
        }, ERROR: { [weak self] et, msg in
            LoadingIndicatorView.hide()
            self?.stack_Container.isHidden = true
            self?.showReloadView()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let changePersonalDataController = (segue.destination as? ChangePersonalDataViewController) {
            changePersonalDataController.pd = self.personalData

        }
    }


}
