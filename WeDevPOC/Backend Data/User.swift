//
//  User.swift
//  WeDevPOC
//
//  Created by Alan Zhang on 11/21/24.
//

import SwiftData
import Observation
import Foundation
import MapKit

@Observable
class UserManager {
    var users: [User] = []
    var currentUser: User?
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
//    Placeholder login function
//    func login(email: String, password: String) -> User? {
//        users.first { $0.email == email && $0.password == password }
//    }
//    Placeholder register function
//    func register(user: User) {
//        users.append(user)
//    }
    
    func fetchUsers() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        self.users = [
            User(firstName: "Alan", lastName: "Zhang", email: "zhang.alan@northeastern.edu", password: "test", location: "New Jersey", preferences: ["Quiet", "Wifi", "Coffee"])
        ]
    }
    
    func updatePreferences(newPreferences: [String]) {
        if currentUser != nil {
            currentUser?.preferences = newPreferences
        }
    }
}

struct User: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
    let email: String
    var password: String
    var location: String
    var preferences: [String]
}
