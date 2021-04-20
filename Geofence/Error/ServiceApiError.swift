//
//  ServiceApiError.swift
//  Geofence
//
//  Created by Matias Cohen on 19/04/2021.
//

import Foundation

enum ServiceApiError: Error {
    case invalidHost
    case invalidUrl
    case invalidResponse
    case businessError
}
