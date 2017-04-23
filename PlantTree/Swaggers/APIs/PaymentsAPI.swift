//
// PaymentsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



open class PaymentsAPI: APIBase {
    /**
     * enum for parameter currency
     */
    public enum Currency_apiPaymentsWebmoneyPost: String { 
        case euro = "Euro"
        case dollar = "Dollar"
        case ruble = "Ruble"
    }

    /**

     - parameter projectId: (query)  (optional)
     - parameter amount: (query)  (optional)
     - parameter treeCount: (query)  (optional)
     - parameter currency: (query)  (optional)
     - parameter authorization: (header) Authorization header parameter (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func apiPaymentsWebmoneyPost(projectId: Int32? = nil, amount: Double? = nil, treeCount: Int32? = nil, currency: Currency_apiPaymentsWebmoneyPost? = nil, authorization: String? = nil, completion: @escaping ((_ error: Error?) -> Void)) {
        apiPaymentsWebmoneyPostWithRequestBuilder(projectId: projectId, amount: amount, treeCount: treeCount, currency: currency, authorization: authorization).execute { (response, error) -> Void in
            completion(error);
        }
    }


    /**
     - POST /api/Payments/webmoney
     
     - parameter projectId: (query)  (optional)
     - parameter amount: (query)  (optional)
     - parameter treeCount: (query)  (optional)
     - parameter currency: (query)  (optional)
     - parameter authorization: (header) Authorization header parameter (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func apiPaymentsWebmoneyPostWithRequestBuilder(projectId: Int32? = nil, amount: Double? = nil, treeCount: Int32? = nil, currency: Currency_apiPaymentsWebmoneyPost? = nil, authorization: String? = nil) -> RequestBuilder<Void> {
        let path = "/api/Payments/webmoney"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "projectId": projectId?.encodeToJSON(), 
            "amount": amount, 
            "treeCount": treeCount?.encodeToJSON(), 
            "currency": currency?.rawValue
        ])
        
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
