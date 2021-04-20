//
//  PostRequest.swift
//  Geofence
//
//  Created by Matias Cohen on 19/04/2021.
//

import UIKit
import PromiseKit

class PostRequest<T: Response> : HttpRequest<T> {

    func postParameters() -> [String: String] {
        return [String: String]()
    }
    
    override func execute() -> Promise<T> {
        return Promise<T> { seal in
            
                let url = try serviceUrl()
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                request.httpBody = try JSONSerialization.data(withJSONObject: postParameters(), options: [])
            
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    
                    if let error = error {
                        seal.reject(error)
                        return
                    }
                    
                    guard let data = data else {
                        seal.reject(ServiceApiError.invalidResponse)
                        return
                    }
                    
                    guard let response = try? self.parseResponse(data: data) else {
                        seal.reject(ServiceApiError.invalidResponse)
                        return
                    }

                    seal.fulfill(response)
                }

                task.resume()
        }
    }
    
}
