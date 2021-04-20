//
//  UserRepository.swift
//  Geofence
//
//  Created by Matias Cohen on 15/04/2021.
//

import UIKit

import CoreData

class UserRepository: Repository<User> {

    func exists(user: User) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id! as CVarArg)
        
        do {
            let users = try context.fetch(request)
            return !users.isEmpty
        } catch {
            return false
        }
    }
    
}
