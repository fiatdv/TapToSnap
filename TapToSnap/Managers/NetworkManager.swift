//
//  NetworkManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    
    static var shared = NetworkManager()

    func requestJSONWithMethod(method: HTTPMethod, urlString: String, param: [String : Any]?, omitLogging: Bool? = false, responseClosure: @escaping (_ responseObject:Data) -> Void, errorClosure: @escaping (_ responseError: Error) -> Void) {
        
        let headers = ["Content-Type":"application/json"]
        
        LoggingManager.Log("Url: \(urlString)")
        if param != nil {
            if (urlString.contains("/auth/login") == false && urlString.contains("/auth/register") == false) {
                LoggingManager.LogUseless("Body: \(param ?? [String:Any]())")
            }
        }
        
        Alamofire.request(urlString, method: method, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            LoggingManager.Log("Request Header: \(headers)")
            LoggingManager.LogUseless("Response Header: \(response.response?.allHeaderFields ?? [AnyHashable : Any]())")
            
            LoggingManager.Log("Url: \(response.request?.httpMethod ?? "") \(urlString)")
            if param != nil {
                // Don't log the body of these calls as it constains users password.
                if (urlString.contains("/auth/login") == false && urlString.contains("/auth/register") == false) {
                    LoggingManager.LogUseless("Body: \(param ?? [String:Any]())")
                }
            }
            LoggingManager.Log("Status: \(response.response?.statusCode ?? 0)")
            
            if (omitLogging == false) {
                LoggingManager.Log("Response: \(response.result.value ?? "")")
            }
            
            if let error = response.result.error {
                self.logNetworkingError(message: error.localizedDescription, urlString: urlString, param: param, response: response)
                
                if (error.localizedDescription == "The operation couldn’t be completed. (kCFErrorDomainCFNetwork error 303.)") {
                    LoggingManager.LogError(error.localizedDescription)
                }
                errorClosure(error)
                return
            }
            if let statusCode = response.response?.statusCode, statusCode >= 400 || statusCode == 0 {
                
                if let result = response.result.value as? [String : Any], let message = result["message"] as? String {
                    errorClosure(SnapError.custom)
                    self.logNetworkingError(message: message, urlString: urlString, param: param, response: response)
                    return
                }
                else if let result = response.result.value as? [String : Any], let message = result["errorMessage"] as? String {
                    errorClosure(SnapError.custom)
                    self.logNetworkingError(message: message, urlString: urlString, param: param, response: response)
                    return
                }
                else {
                    errorClosure(SnapError.custom)
                    self.logNetworkingError(message: "No Error Message", urlString: urlString, param: param, response: response)
                    return
                }
            }
            
            if let result = response.data {
                responseClosure(result)
            }
        }
    }

    func logNetworkingError(message:String, urlString:String, param: [String : Any]?, response:DataResponse<Any>?) {
        LoggingManager.LogError("Error Message: \(message)")
        LoggingManager.LogError("Url: \(response?.request?.httpMethod ?? "") \(urlString)")
        // Don't log the body of these calls as it constains users password.
        if (urlString.contains("/auth/login") == false && urlString.contains("/auth/register") == false) {
            LoggingManager.LogUseless("Body: \(param ?? [String:Any]())")
        }
        LoggingManager.LogError("Response Status Code: \(response?.response?.statusCode ?? 0)")
    }
}
