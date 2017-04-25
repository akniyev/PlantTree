//
// Created by Admin on 24/04/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

extension News {
    func toNewsPiece() -> NewsPiece {
        let n = self
        let np = NewsPiece()

        np.id = Int(n.id ?? -1)
        np.title = n.title ?? ""
        np.date = n.date
        np.description = n.shortText ?? ""
        np.text = n.text ?? ""
        np.imageUrlSmall = n.photoUrlSmall ?? ""
        np.imageUrl = n.photoUrl ?? ""
        return np
    }
}