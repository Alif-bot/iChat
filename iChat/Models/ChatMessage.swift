//
//  ChatMessage.swift
//  iChat
//
//  Created by Md Alif Hossain on 11/2/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    let from: String?
    let to: String?
    let message: String?
}
