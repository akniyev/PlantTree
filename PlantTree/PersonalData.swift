//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

class PersonalData : Equatable {
    var userid : Int = 0
    var firstname = ""
    var secondname = ""
    var gender : Gender = Gender.None
    var birthdate : Date? = nil
    var photoUrl : String = ""
    var photoUrlSmall : String = ""
    var moneyDonated : Int = 0
    var donatedProjectCount : Int = 0
    var email : String = ""
    var email_confirmed : Bool = false
    
    static func ==(lhs: PersonalData, rhs: PersonalData) -> Bool {
        return lhs.email == rhs.email
    }
}
