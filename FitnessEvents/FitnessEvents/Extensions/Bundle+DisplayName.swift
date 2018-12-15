//
//  Bundle+DisplayName.swift
//  FitnessEvents
//
//  Created by Diana Ivascu on 11/30/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation

extension Bundle {
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
