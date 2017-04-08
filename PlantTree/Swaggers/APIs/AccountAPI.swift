//
// AccountAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



open class AccountAPI: APIBase {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountConfirmPost(completion: @escaping ((_ error: Error?) -> Void)) {
        apiAccountConfirmPostWithRequestBuilder().execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     - POST /api/account/confirm

     - returns: RequestBuilder<Void> 
     */
    open class func apiAccountConfirmPostWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/api/account/confirm"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter email: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountForgotByEmailPost(email: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiAccountForgotByEmailPostWithRequestBuilder(email: email).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     - POST /api/account/forgot/{email}
     
     - parameter email: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func apiAccountForgotByEmailPostWithRequestBuilder(email: String) -> RequestBuilder<Void> {
        var path = "/api/account/forgot/{email}"
        path = path.replacingOccurrences(of: "{email}", with: "\(email)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountInfoGet(completion: @escaping ((_ data: UserInfo?,_ error: Error?) -> Void)) {
        apiAccountInfoGetWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     - GET /api/account/info
     - examples: [{contentType=application/json, example={
  "birthday" : "aeiou",
  "donated" : 1.3579000000000001069366817318950779736042022705078125,
  "lastName" : "aeiou",
  "gender" : "aeiou",
  "name" : "aeiou",
  "donatedProjectsCount" : 123,
  "email" : "aeiou",
  "isEmailConfirmed" : true
}}]

     - returns: RequestBuilder<UserInfo> 
     */
    open class func apiAccountInfoGetWithRequestBuilder() -> RequestBuilder<UserInfo> {
        let path = "/api/account/info"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<UserInfo>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     DateTime format - \"dd.MM.yyyy\"
     
     - parameter info: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountInfoPut(info: UserInfoModel? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiAccountInfoPutWithRequestBuilder(info: info).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     DateTime format - \"dd.MM.yyyy\"
     - PUT /api/account/info
     
     - parameter info: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiAccountInfoPutWithRequestBuilder(info: UserInfoModel? = nil) -> RequestBuilder<Void> {
        let path = "/api/account/info"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = info?.encodeToJSON() as? [String:AnyObject]

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Changes password for local user.
     
     - parameter current: (path)  
     - parameter newpass: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountPasswordByCurrentByNewpassPut(current: String, newpass: String, completion: @escaping ((_ error: Error?) -> Void)) {
        apiAccountPasswordByCurrentByNewpassPutWithRequestBuilder(current: current, newpass: newpass).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Changes password for local user.
     - PUT /api/account/password/{current}/{newpass}
     
     - parameter current: (path)  
     - parameter newpass: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func apiAccountPasswordByCurrentByNewpassPutWithRequestBuilder(current: String, newpass: String) -> RequestBuilder<Void> {
        var path = "/api/account/password/{current}/{newpass}"
        path = path.replacingOccurrences(of: "{current}", with: "\(current)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{newpass}", with: "\(newpass)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Accepts requests with Content-Type: application/json and body: {\"email\":\"my@my.ru\", \"password\": \"mypassword\"}
     
     - parameter registerInfo: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiAccountRegisterPost(registerInfo: RegisterModel? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiAccountRegisterPostWithRequestBuilder(registerInfo: registerInfo).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     Accepts requests with Content-Type: application/json and body: {\"email\":\"my@my.ru\", \"password\": \"mypassword\"}
     - POST /api/account/register
     
     - parameter registerInfo: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiAccountRegisterPostWithRequestBuilder(registerInfo: RegisterModel? = nil) -> RequestBuilder<Void> {
        let path = "/api/account/register"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = registerInfo?.encodeToJSON() as? [String:AnyObject]

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
