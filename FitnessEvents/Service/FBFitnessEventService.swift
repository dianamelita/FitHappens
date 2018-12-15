//
//  FBFitnessEventService.swift
//  Service
//
//  Created by Diana Ivascu on 11/7/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Model
import Networking
import Logging

class FBFitnessEventService: FitnessEventService {
    
    private let urlBuilder: FitnessEventUrlBuilder
    private let network: Network
    
    init(urlBuilder: FitnessEventUrlBuilder, network: Network) {
        
        self.urlBuilder = urlBuilder
        self.network = network
    }
    
    func retrieveEvents(from date: Date,
                        completion: @escaping ([FitnessEvent]?, Error?) -> Void) {
        
        log.debugMessage("Started retrieving fitness events starting with date: \(date).")
        guard let fitnessEventUrl = urlBuilder.fitnessEventsUrl(withStartDate: date) else {
            
            completion(nil, ServiceError.urlBuilderFail(details: "Could not build URL for date \(date)"))
            return
        }
        
        let fitnessEventUrlRequest = URLRequest(url: fitnessEventUrl)
        network.perform(request: fitnessEventUrlRequest) { (data, error) in
            
            guard error == nil else {
                
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                
                completion(nil, ServiceError.noDataRetrieved(details: "No data could be retrieved for request \(fitnessEventUrlRequest)"))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                let fitnessEventDictionary = try jsonDecoder.decode([String:FitnessEvent].self,
                                                                    from: data)
                let fitnessEventArray = fitnessEventDictionary.values.map{ $0 }
                completion(fitnessEventArray, nil)
            } catch {

                completion(nil, ServiceError.malformedData(details: "Malformed data was received for request \(fitnessEventUrlRequest)"))
            }
        }
    }
}
