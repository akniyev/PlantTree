//
//  RoundImageView.swift
//  PlantTree
//
//  Created by Admin on 28/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit


class RoundImageView : UIImageView {
    let maskLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circlePath = UIBezierPath(ovalIn: self.bounds)
        self.maskLayer.path = circlePath.cgPath
        self.layer.mask = self.maskLayer
    }
}
