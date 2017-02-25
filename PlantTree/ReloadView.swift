//
//  ReloadView.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ReloadView : UIView {
    var reloadAction : (() -> ())?
    @IBOutlet weak var reloadButton: UIButton!
    @IBAction func reloadTouched(_ sender: Any) {
        reloadAction?()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
