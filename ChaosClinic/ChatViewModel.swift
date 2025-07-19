import Foundation
import FoundationModels
import SwiftData
import Observation
import SwiftUI

@available(iOS 26.0, *)
@MainActor
class ChatViewModel: ObservableObject {
    @Published var isAIResponding = false
    @Published var errorMessage: String?
    @Published var messages: [ChatMessage] = []
    
    private var languageModelSession: LanguageModelSession?
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupLanguageModel()
        messages = fetchMessages()
    }
    
    private func setupLanguageModel() {
        languageModelSession = LanguageModelSession()
    }
    
    func fetchMessages() -> [ChatMessage] {
        let descriptor = FetchDescriptor<ChatMessage>(sortBy: [SortDescriptor(\.timestamp)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func sendMessage(_ content: String) async {
        let userMessage = ChatMessage(content: content, isFromUser: true)
        modelContext.insert(userMessage)
        messages.append(userMessage)
        
        let aiMessage = ChatMessage(content: "", isFromUser: false, isPartial: true)
        modelContext.insert(aiMessage)
        messages.append(aiMessage)
        isAIResponding = true
        do {
            guard let session = languageModelSession else { return }
            let stream = session.streamResponse(to: content)
            for try await response in stream {
                aiMessage.content = response
                try modelContext.save()
                objectWillChange.send()
            }
            aiMessage.isPartial = false
            try modelContext.save()
            isAIResponding = false
        } catch {
            aiMessage.content = "Sorry, I couldn't connect to the AI right now."
            aiMessage.isPartial = false
            try? modelContext.save()
            isAIResponding = false
            errorMessage = error.localizedDescription
        }
    }
}
