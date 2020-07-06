//
//  ApiStatus.swift
//  QappKit
//
//  Created by Marc Heimendinger on 07.05.20.
//  Copyright © 2020 Marc Heimendinger. All rights reserved.
//

import Foundation

public enum ApiStatus: String, Codable {
    case ok, error, networkError
}
