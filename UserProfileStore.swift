//
//  UserProfileStore.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-21.
//
import Foundation

class UserProfileStore: ObservableObject {
    @Published var userProfile: UserProfile? {
        didSet {
            if let profile = userProfile {
                saveProfile(profile)
            }
        }
    }
     
    init() {
        self.userProfile = nil
        loadProfile()
    }
    
    private func getFileURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("user_profile.json")
    }
    
    private func saveProfile(_ profile: UserProfile) {
        do {
            let data = try JSONEncoder().encode(profile)
            try data.write(to: getFileURL())
        } catch {
            print("Error saving user profile: \(error)")
        }
    }
    
    private func loadProfile() {
        let fileURL = getFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            let loadedProfile = try JSONDecoder().decode(UserProfile.self, from: data)
            self.userProfile = loadedProfile
        } catch {
            print("No saved user profile found or error loading: \(error)")
        }
    }
    
    func register(username: String, password: String, age: Int) {
        let newUser = UserProfile(username: username, password: password, age: age)
        self.userProfile = newUser
        print("User registered: \(username), Age: \(age)")
    }

    func authenticateUser(username: String, password: String) -> Bool {
        if let user = userProfile, user.username == username && user.password == password {
            print("Login successful")
            return true
        }
        print("Login failed")
        return false
    }
}