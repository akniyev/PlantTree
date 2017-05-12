//
//  RoundButtonRowNew.swift
//  PlantTree
//
//  Created by Hasan on 09/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class RoundButtonRowNew : Row<RoundButtonCellNew>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<RoundButtonCellNew>(nibName: "RoundButtonCellNew")
        self.baseCell.height = { 65 }
        self.baseCell.backgroundColor = UIColor.clear
    }
    
    func presetGreenBackground() {
        self.fillColor = UIColor(red: 87/255, green: 188/255, blue: 125/255, alpha: 1)
        self.titleTextColor = UIColor.white
        self.fillBackground = true
        self.drawBorder = false
        self.backgroundInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    func presetGreenBorder() {
        self.borderColor = UIColor(red: 87/255, green: 188/255, blue: 125/255, alpha: 1)
        self.titleTextColor = UIColor(red: 87/255, green: 188/255, blue: 125/255, alpha: 1)
        self.fillBackground = false
        self.drawBorder = true
        self.borderWidth = 2
        self.backgroundInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    var baseCellTyped: RoundButtonCellNew {
        get {
            return self.baseCell as! RoundButtonCellNew
        }
    }
    
    var titleForButton: String? {
        set {
            self.baseCellTyped.lblTitle.text = newValue
        }
        get {
            return self.baseCellTyped.lblTitle.text
        }
    }
    
    var titleTextColor: UIColor {
        set {
            self.baseCellTyped.lblTitle.textColor = newValue
            self.baseCellTyped.titleTextColor = newValue
        }
        get {
            return self.baseCellTyped.lblTitle.textColor
        }
    }
    
    var titleTextColorPressed: UIColor? {
        get {
            return baseCellTyped.titleTextColorPressed
        }
        set {
            baseCellTyped.titleTextColorPressed = newValue
        }
    }
    
    var fillBackground: Bool {
        get {
            return baseCellTyped.fillBackground
        }
        set {
            baseCellTyped.fillBackground = newValue
        }
    }
    
    var drawBorder: Bool {
        get {
            return baseCellTyped.drawBorder
        }
        set {
            baseCellTyped.drawBorder = newValue
        }
    }
    
    var fillColor: UIColor {
        get {
            return baseCellTyped.fillColor
        }
        set {
            baseCellTyped.fillColor = newValue
        }
    }
    
    var fillColorPressed: UIColor? {
        get {
            return baseCellTyped.fillColorPressed
        }
        set {
            baseCellTyped.fillColorPressed = newValue
        }
    }
    
    var borderColor: UIColor {
        get {
            return baseCellTyped.borderColor
        }
        set {
            baseCellTyped.borderColor = newValue
        }
    }
    
    var borderColorPressed: UIColor? {
        get {
            return baseCellTyped.borderColorPressed
        }
        set {
            baseCellTyped.borderColorPressed = newValue
        }
    }
    
    var borderWidth : CGFloat {
        get {
            return self.baseCellTyped.borderWidth
        }
        set {
            self.baseCellTyped.borderWidth = newValue
        }
    }
    
    var backgroundInsets : UIEdgeInsets {
        get {
            return self.baseCellTyped.backgroundInsets
        }
        set {
            self.baseCellTyped.backgroundInsets = newValue
        }
    }
}
