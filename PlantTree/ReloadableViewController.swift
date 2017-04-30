//
// Created by Admin on 30/04/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import UIKit

class ReloadableViewController : UIViewController {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var reloadView : ReloadView? = nil

    func showReloadView() {
        if let v = getReloadView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }

    func hideReloadView() {
        if let v = reloadView {
            v.removeFromSuperview()
        }
    }

    func reloadCompleted() {

    }

    func getReloadView() -> ReloadView? {
        if let reloadView = Bundle.main.loadNibNamed("ReloadView", owner: self, options: nil)?.first as? ReloadView {
            self.reloadView = reloadView
            self.reloadView?.reloadAction = {
                self.reloadCompleted()
            }
        } else {
            self.reloadView = nil
        }
        return self.reloadView
    }
}