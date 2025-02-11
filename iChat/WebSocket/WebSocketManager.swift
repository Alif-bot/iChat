//
//  WebSocketManager.swift
//  iChat
//
//  Created by Md Alif Hossain on 8/2/25.
//

import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var messages: [ChatMessage] = []
    let currentUser: String

    init(username: String) {
        self.currentUser = username
        connect()
    }

    func connect() {
        guard let url = URL(string: "ws://localhost:8080") else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        
        // Register user after connection
        let registerData: [String: String] = ["type": "register", "username": currentUser]
        if let jsonData = try? JSONSerialization.data(withJSONObject: registerData) {
            webSocketTask?.send(.data(jsonData)) { error in
                if let error = error {
                    print("Error registering user: \(error)")
                }
            }
        }

        receiveMessage()
    }

    func sendMessage(to recipient: String, message: String) {
        let messageData: [String: String] = [
            "type": "message",
            "from": currentUser,
            "to": recipient,
            "message": message
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: messageData) {
            webSocketTask?.send(.data(jsonData)) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                }
            }
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    switch message {
                    case .string(let text):
                        if let data = text.data(using: .utf8),
                           let receivedMessage = try? JSONDecoder().decode(ChatMessage.self, from: data) {
                            self?.messages.append(receivedMessage)
                        }
                    default:
                        break
                    }
                }
                self?.receiveMessage() // Keep listening for messages
            case .failure(let error):
                print("Error receiving message: \(error)")
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel()
    }
}
