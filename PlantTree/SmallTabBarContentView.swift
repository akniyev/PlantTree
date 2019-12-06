//
// Created by Admin on 26/04/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation
import ESTabBarController_swift

class SmallTabBarContentView : ESTabBarItemContentView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // This view will be used to display "selected" green line
    let selectedView = UIView()
    let selectedViewSize = CGSize(width: 35, height: 6)
    let iconViewSize = CGSize(width: 30, height: 30)
    let iconElevationFromCenter: CGFloat = 3

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.renderingMode = .alwaysOriginal
        self.addSubview(self.selectedView)
        self.selectedView.backgroundColor = DesignerColors.green
        self.sendSubviewToBack(self.selectedView)

    }

    override func updateDisplay() {
        super.updateDisplay()
        self.selectedView.isHidden = !self.selected
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        // laying out selection-bar view
        let parentSize = self.bounds.size
        let parentCenter = self.center
        let bar_frame = CGRect(
                x: parentCenter.x - selectedViewSize.width / 2,
                y: parentSize.height - selectedViewSize.height,
                width: selectedViewSize.width, height: selectedViewSize.height)
        self.selectedView.frame = bar_frame

        // laying out icon
        let icon_frame = CGRect(
                x: parentCenter.x - iconViewSize.width / 2.0,
                y: parentCenter.y - iconViewSize.height / 2.0 - iconElevationFromCenter,
                width: iconViewSize.width,
                height: iconViewSize.height)
        self.imageView.frame = icon_frame
        self.titleLabel.isHidden = true
    }


}
