// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.int32Value as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T;
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [ApiError]
        Decoders.addDecoder(clazz: [ApiError].self) { (source: AnyObject) -> [ApiError] in
            return Decoders.decode(clazz: [ApiError].self, source: source)
        }
        // Decoder for ApiError
        Decoders.addDecoder(clazz: ApiError.self) { (source: AnyObject) -> ApiError in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = ApiError()
            instance.type = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?)
            instance.code = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["code"] as AnyObject?)
            instance.message = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["message"] as AnyObject?)
            return instance
        }


        // Decoder for [AuthToken]
        Decoders.addDecoder(clazz: [AuthToken].self) { (source: AnyObject) -> [AuthToken] in
            return Decoders.decode(clazz: [AuthToken].self, source: source)
        }
        // Decoder for AuthToken
        Decoders.addDecoder(clazz: AuthToken.self) { (source: AnyObject) -> AuthToken in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = AuthToken()
            instance.scope = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["scope"] as AnyObject?)
            instance.tokenType = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["token_type"] as AnyObject?)
            instance.accessToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["access_token"] as AnyObject?)
            instance.expiresIn = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["expires_in"] as AnyObject?)
            instance.refreshToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["refresh_token"] as AnyObject?)
            instance.idToken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["id_token"] as AnyObject?)
            return instance
        }


        // Decoder for [DetailedUserInfo]
        Decoders.addDecoder(clazz: [DetailedUserInfo].self) { (source: AnyObject) -> [DetailedUserInfo] in
            return Decoders.decode(clazz: [DetailedUserInfo].self, source: source)
        }
        // Decoder for DetailedUserInfo
        Decoders.addDecoder(clazz: DetailedUserInfo.self) { (source: AnyObject) -> DetailedUserInfo in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = DetailedUserInfo()
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.gender = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["gender"] as AnyObject?)
            instance.birthday = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["birthday"] as AnyObject?)
            instance.email = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"] as AnyObject?)
            instance.isEmailConfirmed = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isEmailConfirmed"] as AnyObject?)
            instance.donated = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["donated"] as AnyObject?)
            instance.donatedProjectsCount = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["donatedProjectsCount"] as AnyObject?)
            instance.photoUrlSmall = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrlSmall"] as AnyObject?)
            instance.photoUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrl"] as AnyObject?)
            return instance
        }


        // Decoder for [News]
        Decoders.addDecoder(clazz: [News].self) { (source: AnyObject) -> [News] in
            return Decoders.decode(clazz: [News].self, source: source)
        }
        // Decoder for News
        Decoders.addDecoder(clazz: News.self) { (source: AnyObject) -> News in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = News()
            instance.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"] as AnyObject?)
            instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
            instance.text = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["text"] as AnyObject?)
            instance.shortText = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["shortText"] as AnyObject?)
            instance.photoId = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["photoId"] as AnyObject?)
            instance.photoUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrl"] as AnyObject?)
            instance.photoUrlSmall = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["photoUrlSmall"] as AnyObject?)
            instance.date = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["date"] as AnyObject?)
            instance.projectId = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["projectId"] as AnyObject?)
            return instance
        }


        // Decoder for [Project]
        Decoders.addDecoder(clazz: [Project].self) { (source: AnyObject) -> [Project] in
            return Decoders.decode(clazz: [Project].self, source: source)
        }
        // Decoder for Project
        Decoders.addDecoder(clazz: Project.self) { (source: AnyObject) -> Project in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Project()
            instance.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"] as AnyObject?)
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.tag = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["tag"] as AnyObject?)
            instance.description = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?)
            instance.shortDescription = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["shortDescription"] as AnyObject?)
            instance.goal = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["goal"] as AnyObject?)
            instance.reached = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["reached"] as AnyObject?)
            instance.treePrice = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["treePrice"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                instance.status = Project.Status(rawValue: (status))
            }
            
            instance.creationDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["creationDate"] as AnyObject?)
            instance.reachedDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["reachedDate"] as AnyObject?)
            instance.finishedDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["finishedDate"] as AnyObject?)
            if let currency = sourceDictionary["currency"] as? String { 
                instance.currency = Project.Currency(rawValue: (currency))
            }
            
            instance.deleted = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["deleted"] as AnyObject?)
            instance.imageId = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["imageId"] as AnyObject?)
            instance.mainImageUrl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mainImageUrl"] as AnyObject?)
            instance.mainImageUrlSmall = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["mainImageUrlSmall"] as AnyObject?)
            instance.otherImagesUrl = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["otherImagesUrl"] as AnyObject?)
            instance.otherImagesUrlSmall = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["otherImagesUrlSmall"] as AnyObject?)
            instance.likesCount = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["likesCount"] as AnyObject?)
            instance.isLiked = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["isLiked"] as AnyObject?)
            instance.donatorsCount = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["donatorsCount"] as AnyObject?)
            return instance
        }


        // Decoder for [RegisterModel]
        Decoders.addDecoder(clazz: [RegisterModel].self) { (source: AnyObject) -> [RegisterModel] in
            return Decoders.decode(clazz: [RegisterModel].self, source: source)
        }
        // Decoder for RegisterModel
        Decoders.addDecoder(clazz: RegisterModel.self) { (source: AnyObject) -> RegisterModel in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = RegisterModel()
            instance.email = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"] as AnyObject?)
            instance.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?)
            return instance
        }


        // Decoder for [Transaction]
        Decoders.addDecoder(clazz: [Transaction].self) { (source: AnyObject) -> [Transaction] in
            return Decoders.decode(clazz: [Transaction].self, source: source)
        }
        // Decoder for Transaction
        Decoders.addDecoder(clazz: Transaction.self) { (source: AnyObject) -> Transaction in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = Transaction()
            instance.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"] as AnyObject?)
            instance.userId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["userId"] as AnyObject?)
            instance.projectId = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["projectId"] as AnyObject?)
            instance.amount = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["amount"] as AnyObject?)
            instance.treeCount = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["treeCount"] as AnyObject?)
            if let currency = sourceDictionary["currency"] as? String { 
                instance.currency = Transaction.Currency(rawValue: (currency))
            }
            
            instance.creationDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["creationDate"] as AnyObject?)
            instance.finishedDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["finishedDate"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                instance.status = Transaction.Status(rawValue: (status))
            }
            
            instance.paymentMethod = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["paymentMethod"] as AnyObject?)
            return instance
        }


        // Decoder for [UserInfo]
        Decoders.addDecoder(clazz: [UserInfo].self) { (source: AnyObject) -> [UserInfo] in
            return Decoders.decode(clazz: [UserInfo].self, source: source)
        }
        // Decoder for UserInfo
        Decoders.addDecoder(clazz: UserInfo.self) { (source: AnyObject) -> UserInfo in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = UserInfo()
            instance.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            instance.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            instance.gender = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["gender"] as AnyObject?)
            instance.birthday = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["birthday"] as AnyObject?)
            return instance
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}
