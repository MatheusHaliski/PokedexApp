//
//  AuthService.swift
//  IOSPokedex
//
//  Created by Matheus Braschi Haliski on 06/06/25.
//


import CoreData

class AuthService {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func authenticate(username: String, password: String) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try context.fetch(request)
            return !users.isEmpty
        } catch {
            print("Error fetching user: \(error)")
            return false
        }
    }
    
    func register(username: String, password: String) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let users = try context.fetch(request)
            if !users.isEmpty {
                // User already exists
                return false
            }
            
            let newUser = User(context: context)
            newUser.username = username
            newUser.password = password
            try context.save()
            print("CORRECTLY registering user")
            return true
        } catch let error {
            print("Error registering user: \(error.localizedDescription)")
            return false
        }

    }
}
