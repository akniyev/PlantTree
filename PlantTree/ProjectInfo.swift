//
// Created by Admin on 20/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectInfo {
    var id : Int = -1
    var name : String = ""
    var description : String = ""
    var goal : Int = 0
    var reached : Int = 0
    var projectStatus : ProjectStatus = .none
    var mainImageUrlSmall = ""
    var mainImageUrlBig = ""
    var likeCount : Int = 0
    var isLikedByMe : Bool? = nil
    var treePrice : Double = 0.0
}
