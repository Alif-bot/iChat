//
//  ChatMessageView.swift
//  iChat
//
//  Created by Md Alif Hossain on 12/2/25.
//

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage
    let currentUser: String

    var isCurrentUser: Bool {
        return message.from == currentUser
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(isCurrentUser ? "You" : message.from ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(message.message ?? "")
                    .padding()
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .leading)
            }
        }
        .padding(.horizontal)
    }
}
