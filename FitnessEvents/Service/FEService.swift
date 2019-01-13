//
//  FEService.swift
//  Service
//
//  Created by Diana Ivascu on 11/10/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

class FEService: Service {
    
    var authentication: AuthenticationService
    var fitnessEvent: FitnessEventService
    
    init(fitnessEvent: FitnessEventService, authentication: AuthenticationService) {
        
        self.fitnessEvent = fitnessEvent
        self.authentication = authentication
    }
}
