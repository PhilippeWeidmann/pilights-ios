//
//  Platform.swift
//  bachelor
//
//  Created by Philippe Weidmann on 12.07.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
