//
//  RequestManager.swift
//  TapToSnap
//
//  Created by Felipe Gomez on 4/18/20.
//  Copyright © 2020 Hijos de la Luz. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    static var shared = RequestManager()
    
    func APIBaseUrl() -> String {
        return EnvironmentManager.shared.currentEnvironment.APIBaseUrl
    }
    
    func getItems(responseClosure:@escaping (_ items:[Item]) -> Void, errorClosure:@escaping (_ error: Error) -> Void) {
        
        NetworkManager.shared.requestJSONWithMethod(method: .get, urlString: "\(APIBaseUrl())/iositems/items", param: nil, omitLogging: false, responseClosure: { (response) in

            do {
                let items = try JSONDecoder().decode([Item].self, from: response)
                responseClosure(items)
            
            } catch let jsonErr {
                LoggingManager.LogError("Failed to decode json: \(jsonErr)")
            }
            
        }) { (error) in
            errorClosure(error)
        }
    }

    func verifyItem(label:String, image:String, responseClosure:@escaping (_ response:[String:Bool]) -> Void, errorClosure:@escaping (_ error: Error) -> Void) {
        
        let param = ["ImageLabel":label, "Image":image] as [String : Any]
        
        NetworkManager.shared.requestJSONWithMethod(method: .post, urlString: "\(APIBaseUrl())/iositems/items", param: param, responseClosure: { (response) in
            
            do {
                let item = try JSONDecoder().decode([String:Bool].self, from: response)
                responseClosure(item)
                return
            } catch let jsonErr {
                LoggingManager.LogError("Failed to decode - verifyItem: \(jsonErr)")
            }
            LoggingManager.LogError("Failed to verifyItem: \(response)")
            
        }) { (error) in
            errorClosure(error)
        }
    }
}
