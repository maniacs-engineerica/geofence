//
//  TrackSaveMock.swift
//  Geofence
//
//  Created by Matias Cohen on 20/04/2021.
//

import UIKit
import PromiseKit

class TrackSaveMock: TrackSave {

    override func execute() -> Promise<Response> {
        return Promise<Response>{ seal in
            let json = ["success": "true"]
            let response = try Response(json: json)
            seal.fulfill(response)
        }
    }
    
}
