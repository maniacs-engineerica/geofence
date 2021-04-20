//
//  Reflection.swift
//  Geofence
//
//  Created by Matias Cohen on 19/04/2021.
//

import Foundation

func classFromString(_ className: String) -> AnyClass? {
    let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
    let validNamespace = namespace.replacingOccurrences(of: " ", with: "_")
    let cls: AnyClass? = NSClassFromString("\(validNamespace).\(className)") ?? NSClassFromString(className);
    return cls;
}
