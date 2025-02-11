//
//  ChatView.swift
//  iChat
//
//  Created by Md Alif Hossain on 11/2/25.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    @State private var messageText: String = ""
    @State private var recipientUsername: String = ""
    
    var body: some View {
        VStack {
            Text("Logged in as: \(webSocketManager.currentUser)")
                .font(.headline)
                .padding(.top)

            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(spacing: 10) {
                        ForEach(webSocketManager.messages) { message in
                            ChatMessageView(message: message, currentUser: webSocketManager.currentUser)
                                .id(message.id) // Auto-scroll support
                        }
                    }
                    .padding()
                    .onChange(of: webSocketManager.messages) { _ in
                        if let lastMessage = webSocketManager.messages.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            HStack {
                TextField("Recipient", text: $recipientUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)

                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(recipientUsername.isEmpty || messageText.isEmpty)
            }
            .padding()
        }
    }

    private func sendMessage() {
        webSocketManager.sendMessage(to: recipientUsername, message: messageText)
        messageText = ""
    }
}

