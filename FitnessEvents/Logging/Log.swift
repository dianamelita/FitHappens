//
//  Log.swift
//  Logging
//
//  Created by Diana Ivascu on 11/11/18.
//  Copyright © 2018 Diana Melita. All rights reserved.
//

import Foundation
import Willow

public let log = Logger(logLevels: [.all], writers: [ConsoleWriter()])

