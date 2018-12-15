//
//  FENetwork.swift
//  Networking
//
//  Created by Diana Ivascu on 11/4/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Logging

class FENetwork: Network {
    
    func perform(request: URLRequest, completion: @escaping (Data?,Error?) -> Void) {
        
        log.debugMessage("Started performing request \(request).")
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let networkError = error {
                
                completion(nil, networkError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    
                    completion(nil, NetworkError.httpResponseFail(details: "Status code of HTTP response is \(String(describing: response))"))
                    return
            }
            
            completion(data, nil)
        }
        
        dataTask.resume()
    }
}
