//
//  AuthenticationUrlBuilder.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

public class AuthenticationUrlBuilder {
    
    private let authKey: String
    private let baseAuthenticationUrl: URL! = URL(string: "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword")
    private let baseRefreshUrl: URL! = URL(string: "https://securetoken.googleapis.com/v1/token")

    init(authKey: String) {
        
        self.authKey = authKey
    }
    
    func authenticationUrl() -> URL? {
        
        let keyElement = URLQueryItem(name: "key", value: authKey)
        
        var urlComponents = URLComponents(url: self.baseAuthenticationUrl,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [keyElement]
        return urlComponents?.url
    }
    
    func refreshAuthenticationUrl() -> URL? {
        
        let keyElement = URLQueryItem(name: "key", value: authKey)
        
        var urlComponents = URLComponents(url: self.baseRefreshUrl,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [keyElement]
        return urlComponents?.url
    }
}
