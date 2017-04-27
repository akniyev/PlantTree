//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


class LoginButton : UIButton {
    let borderLayer = CALayer()
    
    let green_color = UIColor(red: 87/255, green: 188/255, blue: 126/255, alpha: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    func initUI() {
        self.setTitleColor(self.green_color, for: .normal)
        self.layer.addSublayer(self.borderLayer)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.borderLayer.frame = self.bounds
        self.borderLayer.cornerRadius = self.frame.height / 2
        self.borderLayer.borderColor = self.green_color.cgColor
        self.borderLayer.borderWidth = 3
    }
}

class FacebookButton : UIButton {
    let green_color = UIColor(red: 87/255, green: 188/255, blue: 126/255, alpha: 1)
    let facebook_blue = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    func initUI() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = self.facebook_blue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

func createView() -> UIView {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = UIColor(red: 50 / 255, green: 55 / 255, blue: 80 / 255, alpha: 1)
    
    let lb = LoginButton(frame: CGRect(x: 10, y: 10, width: 250, height: 50))
    let fb = FacebookButton(frame: CGRect(x: 10, y: 100, width: 250, height: 50))
    
    view.addSubview(lb)
    view.addSubview(fb)
    lb.setTitle("Войти в аккаунт", for: .normal)
    fb.setTitle("Войти через Facebook", for: .normal)
    
    return view
}

PlaygroundPage.current.liveView = createView()
