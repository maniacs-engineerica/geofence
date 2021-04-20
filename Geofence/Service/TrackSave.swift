//
//  TrackSave.swift
//  Geofence
//
//  Created by Matias Cohen on 19/04/2021.
//

import UIKit

class TrackSave: PostRequest<Response> {

    var track: Track!
    
    init() {
        super.init(response: String(describing: Response.self))
    }
    
    override func resource() -> String {
        return "tracks"
    }
    
    override func postParameters() -> [String : String] {
        var params = super.postParameters()
        params["userid"] = track.user?.id!.uuidString
        params["latitude"] = track.latitude?.stringValue
        params["longitude"] = track.longitude?.stringValue
        params["beacon"] = track.beacon
        params["type"] = track.entered ? "1" : "0"
        return params
    }
    
}
