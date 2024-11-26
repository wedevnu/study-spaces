//
//  UserView.swift
//  WeDevPOC
//
//  Created by Alan Zhang on 11/21/24.
//

import SwiftUI

struct UserView: View {
    @Bindable var manager: UserManager

    @State private var newPreference: String = "" // State for adding a new preference

    var body: some View {
        NavigationView {
            VStack {
                if manager.isLoggedIn {
                    // Logged-in view
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome, \(manager.currentUser?.firstName ?? "User")!")
                            .font(.largeTitle)
                            .bold()

                        Text("Location: \(manager.currentUser?.location ?? "Unknown")")
                            .font(.subheadline)

                        Text("Email: \(manager.currentUser?.email ?? "Unknown")")
                            .font(.subheadline)

                        // User Preferences Section
                        Text("Preferences:")
                            .font(.headline)
                            .padding(.top)

                        if let preferences = manager.currentUser?.preferences, !preferences.isEmpty {
                            ForEach(preferences, id: \.self) { preference in
                                HStack {
                                    Text(preference)
                                    Spacer()
                                    Button(action: {
                                        // Update preferences directly
                                        var updatedPreferences = preferences
                                        if let index = updatedPreferences.firstIndex(of: preference) {
                                            updatedPreferences.remove(at: index)
                                            manager.updatePreferences(newPreferences: updatedPreferences)
                                        }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        } else {
                            Text("No preferences set.")
                                .italic()
                        }

                        // Add New Preference Section
                        HStack {
                            TextField("Add a preference", text: $newPreference)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.trailing, 8)
                            
                            Button("Add") {
                                guard !newPreference.isEmpty else { return }
                                var updatedPreferences = manager.currentUser?.preferences ?? []
                                updatedPreferences.append(newPreference)
                                manager.updatePreferences(newPreferences: updatedPreferences)
                                newPreference = ""
                            }
                            .buttonStyle(.bordered)
                        }

                        // Logout Button
                        Button("Logout") {
                            manager.currentUser = nil
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .padding(.top)
                    }
                    .padding()
                } else {
                    // Login/Register View
                    VStack(spacing: 10) {
                        Text("Please log in to access your account.")
                            .font(.headline)

                        Button("Login as Alan Zhang") {
                            manager.currentUser = manager.users.first // Mock login
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)

                        Button("Register New User") {
                            // Placeholder for registration
                            let newUser = User(
                                firstName: "New",
                                lastName: "User",
                                email: "new.user@example.com",
                                password: "password",
                                location: "Boston",
                                preferences: []
                            )
                            manager.users.append(newUser)
                            manager.currentUser = newUser
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
            .navigationTitle("User Profile")
        }
    }
}
