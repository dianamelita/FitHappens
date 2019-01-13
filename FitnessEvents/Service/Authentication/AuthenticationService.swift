//
//  AuthenticationService.swift
//  Service
//
//  Created by Diana Ivascu on 12/31/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public protocol AuthenticationService {
    
    var delegate: AuthenticationServiceDelegate? { get set }
    var currentUser: String? { get }
    func authenticate(completion: @escaping (Bool) -> Void)
    func logout()
}
