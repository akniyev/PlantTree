//
//  UserInfo_ext.swift
//  PlantTree
//
//  Created by Admin on 09/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import Foundation

extension DetailedUserInfo {
    func toPersonalData() -> PersonalData {
        let pd = PersonalData()
        let ui = self
        
        pd.userid = -1
        pd.firstname = ui.name ?? ""
        pd.secondname = ui.lastName ?? ""
        pd.gender = Gender.fromJsonCode(code: ui.gender ?? "none")
        pd.birthdate = ui.birthday == nil ? nil : Date.fromRussianFormat(s: ui.birthday!)
        pd.photoUrl = ui.photoUrl ?? ""
        pd.photoUrlSmall = ui.photoUrlSmall ?? ""
        pd.moneyDonated = Int(ui.donated ?? 0)
        pd.donatedProjectCount = Int(ui.donatedProjectsCount ?? 0)
        pd.email_confirmed = ui.isEmailConfirmed ?? false
        pd.email = ui.email ?? ""
        
        return pd
    }
}
