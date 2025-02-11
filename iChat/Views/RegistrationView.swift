//
//  RegistrationView.swift
//  iChat
//
//  Created by Md Alif Hossain on 11/2/25.
//

import SwiftUI

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
