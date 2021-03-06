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

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["name"] = self.name
        nillableDictionary["lastName"] = self.lastName
        nillableDictionary["gender"] = self.gender
        nillableDictionary["birthday"] = self.birthday
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
