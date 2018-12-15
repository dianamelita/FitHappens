//
//  Network.swift
//  Networking
//
//  Created by Diana Ivascu on 11/4/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public protocol Network {
    
    func perform(request: URLRequest, completion: @escaping (Data?,Error?) -> Void)
}
