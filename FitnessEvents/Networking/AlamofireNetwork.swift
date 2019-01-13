//
//  AlamofireNetwork.swift
//  Networking
//
//  Created by Diana Ivascu on 12/21/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Alamofire
import Logging

class AlamofireNetwork: Network {

    func perform(request: URLRequest, completion: @escaping (Data?,Error?) -> Void) {
        
        log.debugMessage("Started performing request \(request).")
        Alamofire.request(request).response { (response) in
            
            if let error = response.error {
                
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response.response,
                httpResponse.statusCode == 200 else {
                    
                    completion(nil, NetworkError.httpResponseFail(details: "Status code of HTTP response is \(String(describing: response))"))
                    return
            }
            
            completion(response.data, nil)
        }
    }
}
