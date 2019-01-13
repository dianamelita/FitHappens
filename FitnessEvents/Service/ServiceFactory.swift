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
        
        let authKey = "REPLACE_WITH_API_KEY"
        let network = NetworkFactory.makeNetwork()
        log.debugMessage("Creating service.")
        let fbFitnessEventService = FBFitnessEventService(urlBuilder: FitnessEventUrlBuilder(),
                                                          network: network)
        let authenticationService = OAuthService(network: network,
                                                               urlBuilder: AuthenticationUrlBuilder(authKey: authKey),
                                                                  credentialStore: SecureCredentialStore())
        return FEService(fitnessEvent: fbFitnessEventService, authentication: authenticationService)
    }
}
