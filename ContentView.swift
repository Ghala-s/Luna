//
//  ContentView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var historyStore: MedicalHistoryStore
    @EnvironmentObject var userProfileStore: UserProfileStore

    var body: some View {
        MainTabView()
            .environmentObject(historyStore)
            .environmentObject(userProfileStore)
    }
}
