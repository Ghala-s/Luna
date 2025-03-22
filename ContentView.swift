import SwiftUI

struct ContentView: View {
    @StateObject private var historyStore = MedicalHistoryStore() // Added environment store

    var body: some View {
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

#Preview {
    ContentView()
}
