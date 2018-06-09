//
//  WebserviceHandler.swift
//  SampleAssesement
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    static let client = APIClient()
    
    func fetchDataTask(urlRequest: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        if Reachability.isConnectedToNetwork(){
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                // do stuff with response, data & error here
                
                if let d = data {
                    if let value = String(data: d, encoding: String.Encoding.ascii) {
                        
                        if let jsonData = value.data(using: String.Encoding.utf8) {
                            
                            do {
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                completion(true, json as AnyObject)
                                
                            } catch {
                                NSLog("ERROR \(error.localizedDescription)")
                                completion(false, nil)
                            }
                        }
                    }
                    
                }
            })
            
            task.resume()
            
        }
    }
}
   
    

