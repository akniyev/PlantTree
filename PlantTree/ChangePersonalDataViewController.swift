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
    var newImage : UIImage? = nil
    var cellImageView : UIImageView? = nil
    var cell : UserPhotoEditCell? = nil
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = img {
            picker.dismiss(animated: true, completion: {
                LoadingIndicatorView.show("Загрузка изображения...")
                Server.UploadUserpic(image: image, SUCCESS: { [weak self] in
                    if let iv = self?.cellImageView {
                        iv.image = image
                    }
                    if let c = self?.cell {
                        c.noPhoto = false
                    }
                    LoadingIndicatorView.hide()
                }, ERROR: { [weak self] et, msg in
                    LoadingIndicatorView.hide()
                    if let _self = self {
                        Alerts.ShowErrorAlertWithOK(sender: _self, title: "Ошибка загрузки", message: "Не удаётся загрузить изображение", completion: nil)
                    }
                })
            })
        }
    }
    
    
    var pd : PersonalData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Личные данные"
        self.form +++ Section() <<< UserPhotoEditRow() { row in
            row.tag = "photo"
            row.value = pd?.photoUrlSmall
            row.imageSelectAction = { [weak self] c in
                self?.cellImageView = c.imgPhoto
                self?.cell = c
                self?.showSourceSelector()
                self?.cell?.update()
            }
            row.imageDeleteAction = { c in
                LoadingIndicatorView.show("Удаление изображения...")
                Server.DeleteUserpic(SUCCESS: {
                    c.imgPhoto.image = nil
                    c.noPhoto = true
                    c.row.value = nil
                    c.update()
                    LoadingIndicatorView.hide()
                }, ERROR: { [weak self] et, msg in
                    LoadingIndicatorView.hide()
                })
            }
        } <<< TextRow() { row in
            row.tag = "firstname"
            row.placeholder = "Введите ваше имя"
            //row.add(rule: RuleRequired())
            row.value = pd?.firstname ?? ""

        } <<< TextRow() { row in
            row.tag = "secondname"
            row.placeholder = "Введите вашу фамилию"
            //row.add(rule: RuleRequired())
            row.value = pd?.secondname ?? ""
        } <<< SegmentedRow<String>("gender") { row in
            row.title = "Ваш пол:"
            row.options = ["Мужской", "Женский", "Не задан"]
            //row.add(rule: RuleRequired())
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
            //row.add(rule: RuleRequired())
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
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            optionMenu.addAction(openPhotoGalleryAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            optionMenu.addAction(openCameraAction)
        }
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func personalDataSaveAction(cell: ButtonCellOf<String>, row: ButtonRow) {
        let errors = form.validate()
        var haveErrors = false
        for row in form.allRows {
            if !row.isValid {
                row.baseCell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
                haveErrors = true
            } else {
                row.baseCell.backgroundColor = UIColor.white
            }
        }
        if !haveErrors {
            let vs = form.values()
            let first_name = (vs["firstname"] as? String) ?? ""
            let second_name = (vs["secondname"] as? String) ?? ""
            let birthdate = (vs["birthdate"] as? Date) ?? Date()
            let gender = Gender.fromRussianFormat(code: (vs["gender"] as? String) ?? "Не задан")
            var image : UIImage? = nil
            if let imgRow = (form.rowBy(tag: "photo") as? UserPhotoEditRow) {
                image = imgRow.GetImage()
            }
            LoadingIndicatorView.show("Обработка...")
            Server.changePersonalData(image: image, first_name: first_name, second_name: second_name, gender: gender, birth_date: birthdate, SUCCESS: {
                LoadingIndicatorView.hide()
                self.navigationController?.popViewController(animated: true)
            }, ERROR: { et, msg in
                LoadingIndicatorView.hide()
                Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
            })
        }
    }
}
