//
//  ReloadView.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ReloadView : UIView {
    @IBOutlet weak var lbl_Text: UILabel!
    var reloadAction : (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initGestureRecognizer()
    }
    
    func initGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapped))

        self.addGestureRecognizer(tap)
    }
    
    @objc func tapped() {
        reloadAction?()
    }
}
