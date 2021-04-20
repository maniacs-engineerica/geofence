//
//  LocationManager.swift
//  Geofence
//
//  Created by Matias Cohen on 18/04/2021.
//

import UIKit

import CoreLocation
import FirebaseCrashlytics

protocol RegionDelegate {
    func didEnterRegion(_ region: CLRegion)
    func didExitRegion(_ region: CLRegion)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    
    private var delegates = [RegionDelegate]()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = true
        manager.allowsBackgroundLocationUpdates = true
        manager.requestAlwaysAuthorization()
    }
    
    func addDelegate(_ delegate: RegionDelegate){
        delegates.append(delegate)
    }
    
    func startForRegion(_ region: CLRegion){
        manager.startMonitoring(for: region)
    }
    
    func stopAll(){
        manager.monitoredRegions.forEach { manager.stopMonitoring(for: $0) }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegates.forEach { $0.didEnterRegion(region) }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegates.forEach { $0.didExitRegion(region) }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
}
