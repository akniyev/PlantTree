//
//  LoginButton.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class RoundBorderButton : UIButton {
    let borderLayer = CALayer()
    
    var borderColor = DesignerColors.green
    var borderWidth: CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    func initUI() {
        self.setTitleColor(self.borderColor, for: .normal)
        self.layer.addSublayer(self.borderLayer)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderLayer.frame = self.bounds
        self.borderLayer.cornerRadius = self.frame.height / 2
        self.borderLayer.borderColor = self.borderColor.cgColor
        self.borderLayer.borderWidth = self.borderWidth
    }
}
