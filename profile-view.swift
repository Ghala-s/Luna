//
//  profile-view.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userProfileStore: UserProfileStore
    @State private var newName: String = ""
    @State private var newAge: String = ""
    @State private var newBirthday: Date = Date()
    @State private var showingDatePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $newName)
                        .onAppear {
                            newName = userProfileStore.userProfile.name
                        }
                    
                    TextField("Age", text: $newAge)
                        .keyboardType(.numberPad)
                        .onAppear {
                            newAge = String(userProfileStore.userProfile.age)
                        }
                    
                    Toggle("Set Birthday", isOn: $showingDatePicker)
                    
                    if showingDatePicker {
                        DatePicker("Birthday", selection: $newBirthday, displayedComponents: .date)
                            .onAppear {
                                if let date = userProfileStore.userProfile.birthday {
                                    newBirthday = date
                                }
                            }
                    }
                    
                    Button("Save Profile") {
                        updateProfile()
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }

    private func updateProfile() {
        let age = Int(newAge) ?? 25
        var updatedProfile = userProfileStore.userProfile
        updatedProfile.name = newName
        updatedProfile.age = age
        updatedProfile.birthday = showingDatePicker ? newBirthday : nil
        userProfileStore.userProfile = updatedProfile
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserProfileStore())
    }
}
