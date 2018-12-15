//
//  AboutViewController.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/29/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import UIKit
import Logging

class AboutViewController: UIViewController {
    
    @IBOutlet private weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersionLabel.text = "App version " + version
        }
    }
    
    @IBAction private func buttonAction(_ sender: Any) {
        
        guard let resourceUrl = URL(string: "http://www.flaticon.com") else {
            
            log.errorMessage("Could not construct URL for flaticon.com")
            return
        }
        
        UIApplication.shared.open(resourceUrl, options: [:]) { (success) in
            
            guard success == true else {
                
                log.errorMessage("Could not open url for event website: \(resourceUrl)")
                return
            }
        }
    }
}
