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

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.renderingMode = .alwaysOriginal
        self.addSubview(self.selectedView)
        self.selectedView.backgroundColor = UIColor.red
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedView.frame = self.bounds

    }


}