//
//  MockNetwork.swift
//  ServiceTests
//
//  Created by Diana Ivascu on 11/9/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Networking

class MockNetwork: Network {
    
    var data: Data? = nil
    var error: Error? = nil
    
    func perform(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
        completion(data, error)
    }
}
