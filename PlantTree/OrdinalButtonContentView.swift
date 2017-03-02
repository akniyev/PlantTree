//
//  OrdinalButtonContentView.swift
//  PlantTree
//
//  Created by Admin on 02/03/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class OrdinalButtonContentView : ESTabBarItemMoreContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.highlightTextColor = UIColor.init(red: 87/255.0, green: 188/255.0, blue: 125/255.0, alpha: 1.0)
        self.renderingMode = .alwaysOriginal
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
