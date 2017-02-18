//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

class PersonalData {
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
}
