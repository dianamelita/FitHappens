//
//  AuthenticationServiceDelegate.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public protocol AuthenticationServiceDelegate {
    
    func retrieveCredentials(completion: @escaping (UserAuthenticationCredentials?, Bool, ((Error?) -> Void)?) -> Void)
}
