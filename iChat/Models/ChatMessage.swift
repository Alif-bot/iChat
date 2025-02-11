//
//  ChatMessage.swift
//  iChat
//
//  Created by Md Alif Hossain on 11/2/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    var id: UUID = UUID()  // Default value for id
    let from: String?
    let to: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case from, to, message
    }
    
    init(from: String?, to: String?, message: String?) {
        self.id = UUID()
        self.from = from
        self.to = to
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()  // Assign a new UUID when decoding
        self.from = try container.decodeIfPresent(String.self, forKey: .from)
        self.to = try container.decodeIfPresent(String.self, forKey: .to)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}
