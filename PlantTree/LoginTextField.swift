//
//  LoginTextField.swift
//  PlantTree
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

//@IBDesignable
class LoginTextField : UITextField {
    //Initializers
    private let iconView = UIImageView()
    private let iconBox = UIView()
    private let lineLayer = CALayer()
    
    @IBInspectable
    private var lineWidth : CGFloat = 2
    
    private var _iconName = ""
    
    @IBInspectable
    var iconName: String {
        get {
            return self._iconName
        }
        set {
            self._iconName = newValue
            iconView.image = UIImage(named: self._iconName)
        }
    }
    
    override var placeholder: String? {
        get {
            return super.attributedPlaceholder?.string
        }
        set {
            let font = UIFont(name: "Helvetica", size: 18)!
            let fontColor = DesignerColors.text_light_gray
            let attributedPlaceholderText =
                NSMutableAttributedString(
                    string: newValue ?? "",
                    attributes: [
                        NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: fontColor]
            )
            self.attributedPlaceholder = attributedPlaceholderText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUi()
    }
    
    func setupUi() {
        self.iconBox.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        self.iconBox.addSubview(self.iconView)
        self.iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.leftView = self.iconBox
        self.leftViewMode = .always
        
        
        self.layer.addSublayer(self.lineLayer)
        self.backgroundColor = .clear
        
        self.textColor = UIColor.white
        
        self.drawBottomLine()
        self.placeholder = super.placeholder
    }
    
    // Helper functions
    
    private func drawBottomLine() {
        self.lineLayer.frame = CGRect(x: 0, y: self.frame.size.height - self.lineWidth, width: self.frame.size.width, height: self.lineWidth)
        self.lineLayer.backgroundColor = UIColor.white.cgColor
    }
    
    // Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBottomLine()
    }
    
    // Interface
    
    func setImage(img: UIImage?) {
        self.iconView.image = img
    }
    
    func setPlaceholderText(text: String) {
        
    }
}
