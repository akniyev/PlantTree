//
// UserInfo.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class UserInfo: JSONEncodable {
    public var name: String?
    public var lastName: String?
    public var gender: String?
    public var birthday: String?
    public var email: String?
    public var isEmailConfirmed: Bool?
    public var donated: Double?
    public var donatedProjectsCount: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["name"] = self.name
        nillableDictionary["lastName"] = self.lastName
        nillableDictionary["gender"] = self.gender
        nillableDictionary["birthday"] = self.birthday
        nillableDictionary["email"] = self.email
        nillableDictionary["isEmailConfirmed"] = self.isEmailConfirmed
        nillableDictionary["donated"] = self.donated
        nillableDictionary["donatedProjectsCount"] = self.donatedProjectsCount?.encodeToJSON()
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}