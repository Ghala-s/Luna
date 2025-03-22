import SwiftUI

struct ContentView: View {
    @StateObject private var userProfileStore = UserProfileStore()
    @StateObject private var historyStore = MedicalHistoryStore() // Added environment store

    var body: some View {
        if userProfileStore.userProfile == nil {
            LoginView() // Shows login if the user is not signed in
        } else {
            TabView {
                // Medical History Tab
                MedicalHistoryView()
                    .tabItem {
                        Label("History", systemImage: "calendar.circle.fill")
                    }

                // Chatbot Tab
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message.fill")
                    }
            }
            .environmentObject(historyStore) // Inject store into environment
        }
    }
}
#Preview {
    ContentView()
}
