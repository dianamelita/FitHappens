//
//  NetworkFactory.swift
//  Networking
//
//  Created by Diana Ivascu on 11/4/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public class NetworkFactory {
    
    public static func makeNetwork() -> Network {
    
        return FENetwork()
    }
}
