//
//  ContentView.swift
//  iChat
//
//  Created by Md Alif Hossain on 8/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var isRegistered = false
    @State private var webSocketManager: WebSocketManager?

    var body: some View {
        VStack {
            if isRegistered, let webSocketManager = webSocketManager {
                ChatView(webSocketManager: webSocketManager)
            } else {
                RegistrationView(username: $username, isRegistered: $isRegistered, webSocketManager: $webSocketManager)
            }
        }
    }
}

struct RegistrationView: View {
    @Binding var username: String
    @Binding var isRegistered: Bool
    @Binding var webSocketManager: WebSocketManager?

    var body: some View {
        VStack {
            Text("Enter your username")
                .font(.headline)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                guard !username.isEmpty else { return }
                webSocketManager = WebSocketManager(username: username)
                isRegistered = true
            }) {
                Text("Register")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}


struct ChatView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    @State private var messageText: String = ""
    @State private var recipientUsername: String = ""

    var body: some View {
        VStack {
            Text("Logged in as: \(webSocketManager.currentUser)")
                .font(.headline)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(webSocketManager.messages) { message in
                        VStack(alignment: .leading) {
                            Text("\(message.from ?? "Unknown") → \(message.to ?? "Unknown")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(message.message ?? "")
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Recipient username", text: $recipientUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)

                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    guard !recipientUsername.isEmpty, !messageText.isEmpty else { return }
                    webSocketManager.sendMessage(to: recipientUsername, message: messageText)
                    messageText = ""
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}


