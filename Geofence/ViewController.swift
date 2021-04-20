//
//  ViewController.swift
//  Geofence
//
//  Created by Matias Cohen on 14/04/2021.
//

import UIKit
import CoreData
import FirebaseCrashlytics

class ViewController: UIViewController {

    private static let proximityUUID = UUID(uuidString: "F80E818A-5599-4B53-B3FD-0754AA2C050B")!
    
    private static let latitude = 36.42005281481694
    private static let longitude = -116.81223260767725
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func geographicDidPress(_ sender: Any) {
        guard let user = getOrCreateUser() else {
            alertInvalidUser()
            return
        }
        
        Crashlytics.crashlytics().setUserID(user.id!.uuidString)
        
        let coords = CLLocationCoordinate2D(latitude: ViewController.latitude, longitude: ViewController.longitude)
        let region = CLCircularRegion(center: coords, radius: 500, identifier: "geographicRegion")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        let geofence = Geofence(forUser: user)
        
        geofence.save = TrackSaveMock()
        
        if !geofence.startGeographic(region: region) {
            alertDisabledFeature()
        }
    }
    
    @IBAction func beaconDidPress(_ sender: Any) {
        guard let user = getOrCreateUser() else {
            alertInvalidUser()
            return
        }
        
        Crashlytics.crashlytics().setUserID(user.id!.uuidString)
        
        let region = CLBeaconRegion(uuid: ViewController.proximityUUID, identifier: "beaconRegion")

        let geofence = Geofence(forUser: user)
        geofence.save = TrackSaveMock()
        
        if !geofence.startBeacon(region: region) {
            alertDisabledFeature()
        }
    }
    
    @IBAction func stopDidPress(_ sender: Any) {
        guard let user = getOrCreateUser() else {
            alertInvalidUser()
            return
        }
        
        Geofence(forUser: user).stopAll()
    }
    
    private func getOrCreateUser() -> User? {
        let repo = RepositoryFactory().userRepository()
        let users = (try? repo.get()) ?? [User]()
        
        if !users.isEmpty {
            return users[0]
        }
        
        let user = repo.create()
        user.id = UUID()
        user.firstName = "Matias"
        user.lastName = "Cohen"
        
        do {
            try user.managedObjectContext?.save()
            return user
        } catch {
            return nil
        }
    }
    
    private func alertInvalidUser(){
        let alert = UIAlertController(title: "Error", message: "Invalid user", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func alertDisabledFeature(){
        let alert = UIAlertController(title: "Error", message: "Feature not available", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

