//
//  Geofence.swift
//  Geofence
//
//  Created by Matias Cohen on 18/04/2021.
//

import UIKit

import CoreLocation
import PromiseKit
import FirebaseCrashlytics

class Geofence: RegionDelegate {
    
    let locationManager: LocationManager
    let user: User
    
    lazy var repository = RepositoryFactory().trackRepository()
    
    lazy var save = TrackSave()

    init(forUser user: User) {
        self.locationManager = LocationManager()
        self.user = user
    }
    
    func startGeographic(region: CLCircularRegion) -> Bool{
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            return false
        }
        startMonitoring(region: region)
        return true
    }
    
    func startBeacon(region: CLBeaconRegion) -> Bool {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            return false
        }
        startMonitoring(region: region)
        return true
    }
    
    func stopAll(){
        locationManager.stopAll()
    }
    
    private func startMonitoring(region: CLRegion){
        locationManager.addDelegate(self)
        locationManager.startForRegion(region)
    }
    
    func didEnterRegion(_ region: CLRegion) {
        trackUserEntered(true, forRegion: region)
    }
    
    func didExitRegion(_ region: CLRegion) {
        trackUserEntered(false, forRegion: region)
    }
    
    private func trackUserEntered(_ entered: Bool, forRegion region: CLRegion){
        let track = repository.create()
        track.entered = entered
        track.user = user
        track.date = Date()
        
        if let region = region as? CLCircularRegion {
            track.latitude = NSDecimalNumber(value: region.center.latitude)
            track.longitude = NSDecimalNumber(value: region.center.longitude)
        } else if let region = region as? CLBeaconRegion {
            track.beacon = region.uuid.uuidString
        }
        
        do{
            try track.managedObjectContext?.save()
            sendPendingTracks()
        } catch let error {
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    private func sendPendingTracks(){
        let predicate = NSPredicate(format: "uploaded = nil")
        do {
            let tracks = try repository.get(predicate: predicate)
            guard !tracks.isEmpty else { return }
            let track = tracks[0]
            
            save.track = track
            
            firstly {
                save.execute()
            }.done { _ in
                track.uploaded = Date()
                try track.managedObjectContext?.save()
                self.sendPendingTracks()
            }.catch { error in
                Crashlytics.crashlytics().record(error: error)
            }
            
        } catch let error {
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
