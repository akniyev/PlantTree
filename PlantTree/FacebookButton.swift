//
//  FacebookButton.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class FacebookButton : UIButton {
    let green_color = UIColor(red: 87/255, green: 188/255, blue: 126/255, alpha: 1)
    let facebook_blue = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    func initUI() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = self.facebook_blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

