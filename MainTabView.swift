//
//  MainTabView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MedicalHistoryView()
                .tabItem { Label("History", systemImage: "calendar.circle.fill") }

            ChatView()
                .tabItem { Label("Chat", systemImage: "message.fill") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
    }
}
