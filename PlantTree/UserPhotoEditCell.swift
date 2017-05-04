//
//  UserPhotoEditCell.swift
//  PlantTree
//
//  Created by Admin on 19/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class UserPhotoEditCell: Cell<String>, CellType {
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnLoadPhoto: UIButton!
    @IBOutlet weak var btnDeletePhoto: UIButton!
    
    var noPhoto : Bool = true
    
    @IBAction func loadPhotoAction(_ sender: Any) {
        (row as? UserPhotoEditRow)?.imageSelectAction?(self)
    }
    
    @IBAction func deletePhotoAction(_ sender: Any) {
        (row as? UserPhotoEditRow)?.imageDeleteAction?(self)
        //update()
    }

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
        imgPhoto.contentMode = .scaleAspectFill
        imgPhoto.clipsToBounds = true
        
        // specify the desired height for our cell
        height = { return 200 }
        
        // set a light background color for our cell
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        let gray = UIColor(red: 133/255, green: 133/255, blue: 133/255, alpha: 1)
        let red = UIColor(red: 250/255, green: 50/255, blue: 50/255, alpha: 1)
        
        if row.value?.isEmpty ?? true {
            imgPhoto.image = UIImage(named: "NoImage")
            btnDeletePhoto.isEnabled = false
            btnDeletePhoto.setTitleColor(gray, for: .normal)
            noPhoto = true
        } else {
            let url = URL(string: row.value!)
            imgPhoto.kf.setImage(with: url)
            btnDeletePhoto.isEnabled = true
            btnDeletePhoto.setTitleColor(red, for: .normal)
            noPhoto = false
        }
    }
    
}
