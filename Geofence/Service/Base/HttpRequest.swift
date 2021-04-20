//
//  HttpRequest.swift
//  Geofence
//
//  Created by Matias Cohen on 19/04/2021.
//

import UIKit
import PromiseKit

class HttpRequest<T: Response> {
    
    private let responseClass: String
    
    init(response: String = String(describing: Response.self)){
        responseClass = response
    }
    
    func resource() -> String {
        fatalError("This method must be implemented by subclass")
    }
    
    func parameters()->[String : String] {
        return [String: String]()
    }
    
    func execute() -> Promise<T> {
        fatalError("This method must be implemented by subclass")
    }
    
    func serviceUrl() throws -> URL {
        guard let path = Bundle.main.path(forResource: "api", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let host = dict["host"] as? String else {
            throw ServiceApiError.invalidHost
        }
        let baseUrl = URL(string: "\(host)\(resource())")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        
        let queryItems = parameters().map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw ServiceApiError.invalidUrl
        }
        
        return url
    }
    
    func parseResponse(data: Data) throws -> T {
        guard let clazz = classFromString(responseClass) as? T.Type else {
            throw ServiceApiError.invalidResponse
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            throw ServiceApiError.invalidResponse
        }
        
        return try clazz.init(json: json)
    }
}

class Response {
    
    required init(json: [AnyHashable : Any]) throws {
        let success = (json["success"] as! NSString).boolValue
        if !success {
            throw ServiceApiError.businessError
        }
    }
    
}
