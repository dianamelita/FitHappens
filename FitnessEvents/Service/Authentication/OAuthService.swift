//
//  OAuthService.swift
//  Service
//
//  Created by Diana Ivascu on 12/22/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Networking
import Logging

public class OAuthService: AuthenticationService {
    
    public var currentUser: String? {
        
        return credentialStore.retrieve(key: OAuthService.userKey) 
    }
    
    public var delegate: AuthenticationServiceDelegate?
    static private let refreshKey = "refreshToken"
    static private let tokenKey = "token"
    static private let userKey = "currentUser"
    private let credentialStore: CredentialStore
    private let network: Network
    private let urlBuilder: AuthenticationUrlBuilder
    
    init(network: Network, urlBuilder: AuthenticationUrlBuilder, credentialStore: CredentialStore) {
        
        self.network = network
        self.urlBuilder = urlBuilder
        self.credentialStore = credentialStore
    }
  
    public func authenticate(completion: @escaping (Bool) -> Void) {
    
        if let refreshToken = credentialStore.retrieve(key: OAuthService.refreshKey) {
            
            refreshAuthorizationToken(withRefreshToken: refreshToken) { (error) in
                
                if let error = error {
                    
                    log.debugMessage("Refresh authentication returned with error: \(error)")
                    self.credentialStore.clear()
                    completion(false)
                    return
                }
                completion(true)
                return
            }
        } else {
            
            cleanAuthentication { (error) in
                
                if let error = error {
                    
                    log.debugMessage("Clean authentication returned with error: \(error)")
                    completion(false)
                    return
                } else {
                    
                    completion(true)
                    return
                }
            }
        }
    }
    
    public func logout() {
        
        credentialStore.clear()
    }
    
    private func refreshAuthorizationToken(withRefreshToken refreshToken: String,
                                           completion: @escaping (Error?) -> Void) {
        
        guard let baseUrl = urlBuilder.refreshAuthenticationUrl() else {
            
            completion(ServiceError.urlBuilderFail(details: "Empty or incorrect refresh authentication url."))
            return
        }
        
        var request = URLRequest(url: baseUrl)
        let postRequestString = "grant_type=refresh_token&refresh_token=\(refreshToken)"
        request.httpMethod = "POST"
        request.httpBody = postRequestString.data(using: .utf8)
        
        network.perform(request: request) { (data, error) in
            
            if let error = error {
                
                log.debugMessage("Refresh authentication returned with error: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                
                completion(ServiceError.noDataRetrieved(details:
                    "Authentication with refresh token request returned with no data."))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                
                let authenticationResponse = try jsonDecoder.decode(AuthenticationRefreshResponse.self,
                                                                    from: data)
                
                self.credentialStore.store(value: authenticationResponse.refreshToken,
                                           at: OAuthService.refreshKey)
                self.credentialStore.store(value: authenticationResponse.token,
                                           at: OAuthService.tokenKey)
                completion(nil)
            } catch {
                
                completion(ServiceError.malformedData(details:
                    "Authentication with refresh token: Data returned from decoder is malformed. Error returned: \(error)"))
            }
        }
    }
    
    private func cleanAuthentication(completion: @escaping (Error?) -> Void) {
        
        guard let delegate = delegate else {
            
            completion(AuthenticationError.noDelegate(details: "Authentication service delegate could not be found."))
            return
        }
        
        delegate.retrieveCredentials { (userCredentials, cancelled, didAuthenticate) in
           
            if cancelled {
                
                log.debugMessage("User cancelled login")
                completion(AuthenticationError.userCancelled(details: "User cancelled the authentication"))
                return
            }
            
            guard let credentials = userCredentials else {
                
                log.debugMessage("No user credentials were provided")
                didAuthenticate?(AuthenticationError.noCredentials(details: "No user credentials."))
                return
            }
        
            self.authenticate(withCredentials: credentials,
                              completion: { (error) in
                                
                if let error = error {
                    
                    log.debugMessage("Authentication with credentials \(credentials) returned with error \(error)")
                    
                    didAuthenticate?(error)
                    return
                } else {
                    
                    didAuthenticate?(nil)
                }
                completion(nil)
            })
        }
    }
    
    private func authenticate(withCredentials credentials: UserAuthenticationCredentials,
                              completion: @escaping (Error?) -> Void) {
        
        guard let baseUrl = urlBuilder.authenticationUrl() else {
            
            completion(ServiceError.urlBuilderFail(details: "Failure in building the authentication url."))
            return
        }
        
        let urlJsonComponents: [String: Any] = ["email": credentials.email,
                                                "password": credentials.password,
                                                "returnSecureToken": true]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: urlJsonComponents, options: .prettyPrinted)
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        network.perform(request: request) { (data, error) in
            
            if let error = error {
                
                log.debugMessage("Clean authentication returned with error: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                
                completion(ServiceError.noDataRetrieved(details:
                    "Clean authentication with credentials token request returned with no data."))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                
                let authenticationResponse = try jsonDecoder.decode(AuthenticationResponse.self,
                                                                    from: data)
                
                self.credentialStore.store(value: authenticationResponse.refreshToken,
                                           at: OAuthService.refreshKey)
                self.credentialStore.store(value: authenticationResponse.token,
                                           at: OAuthService.tokenKey)
                self.credentialStore.store(value: authenticationResponse.email,
                                           at: OAuthService.userKey)
                completion(nil)
            } catch {
                
                completion(ServiceError.malformedData(details:
                    "Clean authentication with cerdentials: Data returned from decoder is malformed. The following error was returned: \(error)"))
            }
        }
    }
}
