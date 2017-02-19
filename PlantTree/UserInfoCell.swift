//
//  UserInfoCell.swift
//  PlantTree
//
//  Created by Admin on 19/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class UserInfoCell: Cell<PersonalData>, CellType {
    @IBOutlet weak var imgUserPic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSecondName: UILabel!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var lblGender: UILabel!

    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case.
        // If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        // configure our profile picture imageView
        imgUserPic.contentMode = .scaleAspectFill
        imgUserPic.clipsToBounds = true
        
        // specify the desired height for our cell
        height = { return 100 }
        
        // set a light background color for our cell
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }

    override func update() {
        super.update()
        
        lblName.text = ""
        lblSecondName.text = ""
        lblBirthdate.text = ""
        lblGender.text = ""
        // get the value from our row
        guard let user : PersonalData = row.value else { return }
        
        // set the image to the userImageView. You might want to do this with AlamofireImage or another similar framework in a real project
        imgUserPic.image = UIImage(named: "NoImage")
        if user.photoUrlSmall != "" {
            imgUserPic.kf.indicatorType = .activity
            let url = URL(string: user.photoUrlSmall)
            imgUserPic.kf.setImage(with: url)
        }
        
        // set the texts to the labels
        lblName.text = user.firstname
        lblSecondName.text = user.secondname
        lblBirthdate.text = "Дата рождения: \(user.birthdate?.toRussianFormat() ?? "-")"
        lblGender.text = "Пол: \(user.gender.toRussianFormat())"
    }
}
