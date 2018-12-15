//
//  FEService.swift
//  Service
//
//  Created by Diana Ivascu on 11/10/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

 class FEService: Service {
    
    var fitnessEvent: FitnessEventService
    
    init(fitnessEvent: FitnessEventService) {
        
        self.fitnessEvent = fitnessEvent
    }
}
