//
//  RoundButtonRow.swift
//  PlantTree
//
//  Created by Admin on 04/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class RoundButtonRow : Row<RoundButtonCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<RoundButtonCell>(nibName: "RoundButtonCell")
        self.baseCell.height = { 70 }
        self.baseCell.backgroundColor = UIColor.clear
    }
    
    var button : RoundBorderButton? {
        get {
            return (self.baseCell as? RoundButtonCell)?.roundButton
        }
    }
    
    var action : (() -> ())? = nil
    
    override var value: String? {
        get {
            return self.button?.title(for: .normal)
        }
        set {
            self.button?.setTitle(newValue, for: .normal)
        }
    }
}
