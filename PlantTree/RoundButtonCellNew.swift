//
//  RoundButtonCellNewTableViewCell.swift
//  PlantTree
//
//  Created by Hasan on 09/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class RoundButtonCellNew: Cell<String>, CellType {
    @IBOutlet weak var lblTitle: UILabel!
    
    var borderLayer: CALayer {
        get {
            return self.contentView.layer
        }
    }
    
    var titleTextColor: UIColor = UIColor.black
    var titleTextColorPressed: UIColor? = nil
    var fillColor: UIColor = UIColor.red
    var fillColorPressed: UIColor? = nil
    var borderColor: UIColor = UIColor.clear
    var borderColorPressed: UIColor? = nil
    var borderWidth: CGFloat = 2
    var fillBackground = true
    var drawBorder = true
    var backgroundInsets = UIEdgeInsets()
    
    var animationDuration = 0.1

    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawButton()
        self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.width, bottom: 0, right: 0)
    }
    
    func drawButton() {
        let f = self.bounds
        let i = self.backgroundInsets
        let f1 = CGRect(x: f.origin.x + i.left, y: f.origin.y + i.top, width: f.width - i.left - i.right, height: f.height - i.top - i.bottom)
        self.borderLayer.frame = f1
        
        self.borderLayer.cornerRadius = self.borderLayer.frame.height / 2
        self.borderLayer.borderColor = self.borderColor.cgColor
        self.borderLayer.borderWidth = self.drawBorder ? self.borderWidth : 0
        if self.fillBackground {
            self.borderLayer.backgroundColor = self.fillColor.cgColor
        } else {
            self.borderLayer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.addSublayer(self.borderLayer)
//        self.contentView.layer.addSublayer(self.borderLayer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.highlightAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.unhighlightAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unhighlightAnimation()
    }
    
    func highlightAnimation() {
        if self.fillBackground {
            let backgroundAnimation = CABasicAnimation(keyPath: "backgroundColor")
            backgroundAnimation.isRemovedOnCompletion = false
            backgroundAnimation.fillMode = kCAFillModeForwards
            backgroundAnimation.fromValue = self.fillColor.cgColor
            backgroundAnimation.toValue = self.fillColorPressed?.cgColor ?? self.fillColor.withAlphaComponent(0.5).cgColor
            backgroundAnimation.duration = self.animationDuration
            backgroundAnimation.repeatCount = 1
            self.borderLayer.add(backgroundAnimation, forKey: "backgroundColor")
        }
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = kCAFillModeForwards
        borderColorAnimation.fromValue = self.borderColor.cgColor
        borderColorAnimation.toValue = self.borderColorPressed?.cgColor ?? self.borderColor.withAlphaComponent(0.5).cgColor
        borderColorAnimation.repeatCount = 1
        borderColorAnimation.duration = self.animationDuration
        self.borderLayer.add(borderColorAnimation, forKey: "borderColor")
        
        lblTitle.textColor = self.titleTextColorPressed ?? self.titleTextColor.withAlphaComponent(0.5)
    }
    
    func unhighlightAnimation() {
        if self.fillBackground {
            let backgroundAnimation = CABasicAnimation(keyPath: "backgroundColor")
            backgroundAnimation.isRemovedOnCompletion = false
            backgroundAnimation.fillMode = kCAFillModeForwards
            backgroundAnimation.fromValue = self.fillColorPressed?.cgColor ?? self.fillColor.withAlphaComponent(0.5).cgColor
            backgroundAnimation.toValue = self.fillColor.cgColor
            backgroundAnimation.duration = self.animationDuration
            backgroundAnimation.repeatCount = 1
            self.borderLayer.add(backgroundAnimation, forKey: "backgroundColor")
        }
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = kCAFillModeForwards
        borderColorAnimation.fromValue = self.borderColorPressed?.cgColor ?? self.borderColor.withAlphaComponent(0.5).cgColor
        borderColorAnimation.toValue = self.borderColor.cgColor
        borderColorAnimation.repeatCount = 1
        borderColorAnimation.duration = self.animationDuration
        self.borderLayer.add(borderColorAnimation, forKey: "borderColor")
        
        lblTitle.textColor = self.titleTextColor
    }
    
    

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
//        let txtColorNormal = titleTextColor
//        let txtColorPressed = titleTextColorPressed ?? txtColorNormal.withAlphaComponent(0.5)
//        
//        let txtColor = highlighted ? txtColorPressed : txtColorNormal
//        self.lblTitle.textColor = txtColor
        
    }
}
