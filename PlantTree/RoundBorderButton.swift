//
//  LoginButton.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBorderButton : UIButton {
    let borderLayer = CALayer()
    
    @IBInspectable
    var borderColor: UIColor = UIColor.green
    
    @IBInspectable
    var borderColorPressed: UIColor = UIColor.black
    
    @IBInspectable
    var borderWidth: CGFloat = 3
    
    @IBInspectable
    var fillColor: UIColor = UIColor.white
    
    @IBInspectable
    var fillColorPressed: UIColor = UIColor.black
    
    @IBInspectable
    var filled: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    func initUI() {
        self.layer.addSublayer(self.borderLayer)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeUp()
    }
    
    func makeUp() {
        self.borderLayer.frame = self.bounds
        self.borderLayer.cornerRadius = self.frame.height / 2
        self.borderLayer.borderColor = self.borderColor.cgColor
        self.borderLayer.borderWidth = self.borderWidth
        if self.filled {
            self.borderLayer.backgroundColor = self.fillColor.cgColor
        } else {
            self.borderLayer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("BEGIN")
        let backgroundAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundAnimation.isRemovedOnCompletion = false
        backgroundAnimation.fillMode = kCAFillModeForwards
        backgroundAnimation.fromValue = self.fillColor.cgColor
        backgroundAnimation.toValue = self.fillColorPressed.cgColor
        backgroundAnimation.duration = 0.1
        backgroundAnimation.repeatCount = 1
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = kCAFillModeForwards
        borderColorAnimation.fromValue = self.borderColor.cgColor
        borderColorAnimation.toValue = self.borderColorPressed.cgColor
        borderColorAnimation.repeatCount = 1
        borderColorAnimation.duration = 0.1
        self.borderLayer.add(backgroundAnimation, forKey: "backgroundColor")
        self.borderLayer.add(borderColorAnimation, forKey: "borderColor")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("END")
        let backgroundAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundAnimation.isRemovedOnCompletion = false
        backgroundAnimation.fillMode = kCAFillModeForwards
        backgroundAnimation.fromValue = self.fillColorPressed.cgColor
        backgroundAnimation.toValue = self.fillColor.cgColor
        backgroundAnimation.duration = 0.1
        backgroundAnimation.repeatCount = 1
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.isRemovedOnCompletion = false
        borderColorAnimation.fillMode = kCAFillModeForwards
        borderColorAnimation.fromValue = self.borderColorPressed.cgColor
        borderColorAnimation.toValue = self.borderColor.cgColor
        borderColorAnimation.repeatCount = 1
        borderColorAnimation.duration = 0.1
        self.borderLayer.add(backgroundAnimation, forKey: "backgroundColor")
        self.borderLayer.add(borderColorAnimation, forKey: "borderColor")
    }
}
