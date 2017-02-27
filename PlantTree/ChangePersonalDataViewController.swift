//
//  ChangePersonalDataViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class ChangePersonalDataViewController : FormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var pd : PersonalData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Личные данные"
        self.form +++ Section() <<< UserPhotoEditRow() { row in
            row.tag = "photo"
            row.value = pd?.photoUrlSmall
            row.imageSelectAction = { c in
                self.showSourceSelector()
            }
        } <<< TextRow() { row in
            row.tag = "firstname"
            row.placeholder = "Введите ваше имя"
            row.add(rule: RuleRequired())
            row.value = pd?.firstname ?? ""

        } <<< TextRow() { row in
            row.tag = "secondname"
            row.placeholder = "Введите вашу фамилию"
            row.add(rule: RuleRequired())
            row.value = pd?.secondname ?? ""
        } <<< SegmentedRow<String>("gender") { row in
            row.title = "Ваш пол:"
            row.options = ["Мужской", "Женский", "Не задан"]
            row.add(rule: RuleRequired())
            if pd == nil {
                row.value = "Не задан"
            } else {
                switch pd!.gender {
                case .Female: row.value = "Женский"
                case .Male: row.value = "Мужской"
                case .None: row.value = "Не задан"
                }
            }
        } <<< DateRow() { row in
            row.title = "Дата рождения"
            row.tag = "birthdate"
            row.add(rule: RuleRequired())
            row.value = pd?.birthdate ?? nil
        }
        +++ Section() <<< ButtonRow() { row in
            row.title = "Сохранить"
            row.onCellSelection(self.personalDataSaveAction)
        }
    }
    
    func showSourceSelector() {
        let optionMenu = UIAlertController(title: nil, message: "Источник фотографии", preferredStyle: .actionSheet)
        
        let openPhotoGalleryAction = UIAlertAction(title: "Выбрать из галереи", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let openCameraAction = UIAlertAction(title: "Снимок с камеры", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(openPhotoGalleryAction)
        optionMenu.addAction(openCameraAction)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func personalDataSaveAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        let errors = form.validate()
        
        for row in form.allRows {
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
    }
}
