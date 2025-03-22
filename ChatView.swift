//
//  ChatView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var isLoading = false
    @EnvironmentObject var historyStore: MedicalHistoryStore
    @EnvironmentObject var userProfileStore: UserProfileStore

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    MessageView(message: message)
                }
            }

            HStack {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(inputText.isEmpty)
            }
            .padding()

            if isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Chat")
        .padding()
    }

    func sendMessage() {
        let userMessage = Message(sender: "User", content: inputText)
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        OpenAIService.shared.sendMessage(
            prompt: userMessage.content,
            historyStore: historyStore,
            userProfile: userProfileStore.userProfile
        ) { response in
            DispatchQueue.main.async {
                let botReply = Message(sender: "AI", content: response)
                messages.append(botReply)
                isLoading = false
            }
        }
    }
}
