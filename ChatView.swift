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
    @ObservedObject var userProfileStore: UserProfileStore
    @ObservedObject var historyStore: MedicalHistoryStore
    
    // Add these default parameters for preview and backward compatibility
    init(historyStore: MedicalHistoryStore = MedicalHistoryStore(), userProfileStore: UserProfileStore = UserProfileStore()) {
        self.historyStore = historyStore
        self.userProfileStore = userProfileStore
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        HStack {
                            if message.sender == "User" {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.purple.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing))

            HStack {
                TextField("How are you feeling today?", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                Button(action: sendMessage) {
                    Text("Send")
                        .bold()
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
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

        OpenAIService.shared.sendMessage(
            prompt: userMessage.content,
            historyStore: historyStore,
            userProfileStore: userProfileStore
        ) { response in
            DispatchQueue.main.async {
                let botReply = Message(sender: "Luna", content: response)
                messages.append(botReply)
                isLoading = false
            }
        }
    }
}