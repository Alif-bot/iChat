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
