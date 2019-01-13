//
//  TabBarController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/20/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Service
import Logging

class TabBarController: UITabBarController {
    
    private var service = ServiceFactory.makeService()

    override func viewDidLoad() {
        
        service.authentication.delegate = self
        
        if let fitnessEventsViewController = self.viewControllers?.first?.children.first
            as? FitnessEventsViewController {
            
            fitnessEventsViewController.service = service
        }
        
        if let settingsViewController = self.viewControllers?.last?.children.first as?
            SettingsViewController {
            
            settingsViewController.service = service
        }
    }
}

extension TabBarController: AuthenticationServiceDelegate {

    func retrieveCredentials(completion: @escaping (UserAuthenticationCredentials?, Bool, ((Error?) -> Void)?) -> Void) {
        
        if let loginViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
            as? LoginViewController {
            
            loginViewController.didSubmit = { (email, password, cancelled) in
                
                guard cancelled == false else {
                    
                    self.dismiss(animated: false, completion: nil)
                    completion(nil, true) { _ in }
                    return
                }
                
                if let email = email,
                    let password = password {
                    
                    let userCredentials = UserAuthenticationCredentials(email: email, password: password)
                    
                    log.debugMessage("Completing credentials retrieval with: \(userCredentials)")
                    completion(userCredentials, false) { error in
                        
                        guard error == nil else {
                            
                            loginViewController.setMessageLabel(text: "Failed to authenticate with given credentials. \n Please try again.")
                            return
                        }
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }            
            present(loginViewController, animated: false, completion: nil)
        }
    }
}
