
import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let sender: String 
    let content: String
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var isLoading = false
    @StateObject private var historyStore = MedicalHistoryStore()
    @StateObject private var userProfileStore = UserProfileStore()

    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if message.sender == "User" {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            HStack {
                TextField("How are you feeling today?", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    sendMessage()
                }
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle("Luna Chat")
    }
    
    func sendMessage() {
        let userMessage = Message(sender: "User", content: inputText)
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        OpenAIService.shared.sendMessage(prompt: userMessage.content, historyStore: historyStore, userProfileStore: userProfileStore) { response in
            DispatchQueue.main.async {
                let botReply = Message(sender: "AI", content: response)
                messages.append(botReply)
                isLoading = false
            }
        }
    }

}

#Preview {
    ChatView()
}
