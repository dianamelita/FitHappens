//
//  ServiceFactory.swift
//  Service
//
//  Created by Diana Ivascu on 11/10/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Networking
import Logging

public class ServiceFactory {
    
    public static func makeService() -> Service {
        
        log.debugMessage("Creating service.")
        let fbFitnessEventService = FBFitnessEventService(urlBuilder: FitnessEventUrlBuilder(),
                                                          network: NetworkFactory.makeNetwork())
        return FEService(fitnessEvent: fbFitnessEventService)
    }
}
