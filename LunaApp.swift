//
//  LunaApp.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//

import SwiftUI

@main
struct Luna: App {
    @StateObject private var historyStore = MedicalHistoryStore()
    @StateObject private var userProfileStore = UserProfileStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyStore)
                .environmentObject(userProfileStore)
        }
    }
}
