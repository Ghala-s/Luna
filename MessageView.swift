//
//  MessageView.swift
//  Luna
//
//  Created by Prabhjot Kaur on 2025-03-22.
//
import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.sender == "User" {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.black)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
