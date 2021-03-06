//
// News.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class News: JSONEncodable {
    public var id: Int32?
    public var title: String?
    public var text: String?
    public var shortText: String?
    public var photoId: Int32?
    public var photoUrl: String?
    public var photoUrlSmall: String?
    public var date: Date?
    public var projectId: Int32?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["id"] = self.id?.encodeToJSON()
        nillableDictionary["title"] = self.title
        nillableDictionary["text"] = self.text
        nillableDictionary["shortText"] = self.shortText
        nillableDictionary["photoId"] = self.photoId?.encodeToJSON()
        nillableDictionary["photoUrl"] = self.photoUrl
        nillableDictionary["photoUrlSmall"] = self.photoUrlSmall
        nillableDictionary["date"] = self.date?.encodeToJSON()
        nillableDictionary["projectId"] = self.projectId?.encodeToJSON()
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
