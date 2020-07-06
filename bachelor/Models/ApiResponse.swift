//
//  ApiResponse.swift
//  bachelor
//
//  Created by Philippe Weidmann on 07.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class ApiResponse<JsonData: Codable>: Codable {

    public let status: ApiStatus
    public let message: String
    public let data: JsonData?

    init(status: ApiStatus, message: String) {
        self.status = status
        self.message = message
        self.data = nil
    }
}
