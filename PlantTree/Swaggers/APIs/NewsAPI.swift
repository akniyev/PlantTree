//
// NewsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



open class NewsAPI: APIBase {
    /**

     - parameter id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiNewsByIdGet(id: Int32, completion: @escaping ((_ data: News?,_ error: Error?) -> Void)) {
        apiNewsByIdGetWithRequestBuilder(id: id).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     - GET /api/news/{id}
     - examples: [{contentType=application/json, example={
  "date" : "2000-01-23T04:56:07.000+00:00",
  "photoUrl" : "aeiou",
  "shortText" : "aeiou",
  "photoId" : 123,
  "id" : 123,
  "text" : "aeiou",
  "title" : "aeiou",
  "projectId" : 123,
  "photoUrlSmall" : "aeiou"
}}]
     
     - parameter id: (path)  

     - returns: RequestBuilder<News> 
     */
    open class func apiNewsByIdGetWithRequestBuilder(id: Int32) -> RequestBuilder<News> {
        var path = "/api/news/{id}"
        path = path.replacingOccurrences(of: "{id}", with: "\(id)", options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)


        let requestBuilder: RequestBuilder<News>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter projectId: (query)  (optional)
     - parameter page: (query)  (optional)
     - parameter pagesize: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiNewsGet(projectId: Int32? = nil, page: Int32? = nil, pagesize: Int32? = nil, completion: @escaping ((_ data: [News]?,_ error: Error?) -> Void)) {
        apiNewsGetWithRequestBuilder(projectId: projectId, page: page, pagesize: pagesize).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     - GET /api/news
     - examples: [{contentType=application/json, example=[ {
  "date" : "2000-01-23T04:56:07.000+00:00",
  "photoUrl" : "aeiou",
  "shortText" : "aeiou",
  "photoId" : 123,
  "id" : 123,
  "text" : "aeiou",
  "title" : "aeiou",
  "projectId" : 123,
  "photoUrlSmall" : "aeiou"
} ]}]
     
     - parameter projectId: (query)  (optional)
     - parameter page: (query)  (optional)
     - parameter pagesize: (query)  (optional)

     - returns: RequestBuilder<[News]> 
     */
    open class func apiNewsGetWithRequestBuilder(projectId: Int32? = nil, page: Int32? = nil, pagesize: Int32? = nil) -> RequestBuilder<[News]> {
        let path = "/api/news"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "projectId": projectId?.encodeToJSON(), 
            "page": page?.encodeToJSON(), 
            "pagesize": pagesize?.encodeToJSON()
        ])
        

        let requestBuilder: RequestBuilder<[News]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
