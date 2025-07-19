import Foundation
import SwiftData

@Model
final class ChatMessage {
    var id: UUID
    var content: String
    var isFromUser: Bool
    var timestamp: Date
    var isPartial: Bool // For streaming responses

    init(content: String, isFromUser: Bool, isPartial: Bool = false) {
        self.id = UUID()
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = Date()
        self.isPartial = isPartial
    }
}
