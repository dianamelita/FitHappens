//
//  FitnessEventService.swift
//  Networking
//
//  Created by Diana Ivascu on 11/7/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Model

public protocol FitnessEventService {
    
    func retrieveEvents(from date: Date, completion: @escaping ([FitnessEvent]?, Error?) -> Void)
}
