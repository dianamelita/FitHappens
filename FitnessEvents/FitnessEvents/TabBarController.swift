//
//  TabBarController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/20/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Service

class TabBarController: UITabBarController {
    
    private var service = ServiceFactory.makeService()
    
    override func viewDidLoad() {
        
        if let fitnessEventsViewController = self.viewControllers?.first?.children.first
            as? FitnessEventsViewController {
            
            fitnessEventsViewController.service = service
        }
    }
}
