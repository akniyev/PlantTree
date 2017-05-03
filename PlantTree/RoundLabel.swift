//
// Created by Admin on 03/05/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import UIKit

class RoundLabel : UILabel {
    let maskLayer = CAShapeLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.mask = self.maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(ovalIn: self.bounds)
        self.maskLayer.path = path.cgPath
    }
}
