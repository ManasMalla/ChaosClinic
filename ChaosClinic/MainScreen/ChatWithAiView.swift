//
//  SwiftUIView.swift
//  Chaos Clinic
//
//  Created by Manas Malla on 16/07/25.
//

import SwiftUI

#if canImport(FoundationModels)
import FoundationModels
import SwiftData
import Observation
#endif

// This conditional compilation provides a fallback chat implementation if FoundationModels is unavailable,
// ensuring the app works with or without FoundationModels support, always providing a chat experience.

#if canImport(FoundationModels)
@available(iOS 26.0, *)
struct ChatWithAiViewContainer: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selection: AppTabState
    let emotion: Emotion
    
    var body: some View {
        ChatWithAiView(selection: $selection, emotion: emotion, modelContext: modelContext)
    }
}

@available(iOS 26.0, *)
struct ChatWithAiView: View {
    
    @Binding var selection: AppTabState
    let emotion: Emotion
    @StateObject private var viewModel: ChatViewModel
    
    @State private var userInput: String = ""
    @State private var showError = false
    
    init(selection: Binding<AppTabState>, emotion: Emotion, modelContext: ModelContext) {
        self._selection = selection
        self.emotion = emotion
        _viewModel = StateObject(wrappedValue: ChatViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        VStack {
            appBar
                .padding()
                .background(
                    Rectangle()
                        .fill(ChaosClinicTheme.getColor(red: 102, green: 36, blue: 160, alpha: 1))
                        .shadow(color: .black.opacity(0.07), radius: 5, y: 8)
                )
            Spacer()
            
            conversationSection
                .padding(.bottom)
                .padding(.horizontal)
            
            messagingSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(stops: [
                .init(color: ChaosClinicTheme.getColor(red: 102, green: 36, blue: 160, alpha: 1), location: 0.1207),
                .init(color: .white, location: 0.6)
            ], startPoint: .init(x: 0.75, y: 0.2), endPoint: .init(x: 0.25, y: 1))
        )
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")) {
                viewModel.errorMessage = nil
            })
        }
        .onChange(of: viewModel.errorMessage) { _ in
            showError = viewModel.errorMessage != nil
        }
    }
}

@available(iOS 26.0, *)
extension ChatWithAiView {
    var appBar: some View {
        HStack {
            Image(systemName: "arrow.left")
                .padding()
                .onTapGesture {
                    selection = .Dashboard
                }
            Spacer()
            ChaosClinicLogo(colorScheme: .dark, maxHeight: 54)
                .overlay(
                    Text("A.I.")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(0.3))
                        )
                        .offset(x: 12, y: 2)
                        .scaleEffect(0.7),
                    alignment: .bottomTrailing
                )
        }
        .foregroundStyle(.white)
    }
    
    var conversationSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.messages) { message in
                        messageView(message)
                            .id(message.id)
                            .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                    }
                    if viewModel.isAIResponding {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: ChaosClinicTheme.aiPurpleAccent))
                            Text("Kanha is typing...")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                .background(Capsule().fill(Color.white))
                        )
                        .id("loadingIndicator")
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                } else if viewModel.isAIResponding {
                    withAnimation {
                        proxy.scrollTo("loadingIndicator", anchor: .bottom)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            Text(message.content)
                .font(.callout)
                .foregroundColor(message.isFromUser ? .white : .black)
                .padding(.vertical, 12)
                .padding(.horizontal, message.isFromUser ? 28 : 24)
                .background(
                    Group {
                        if message.isFromUser {
                            Capsule()
                                .fill(ChaosClinicTheme.getColor(red: 188, green: 159, blue: 214, alpha: 1))
                        } else {
                            Capsule()
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                .background(Capsule().fill(Color.white))
                        }
                    }
                )
                .opacity(message.isPartial ? 0.5 : 1.0)
                .frame(maxWidth: .infinity, alignment: message.isFromUser ? .trailing : .leading)
                .animation(.easeInOut(duration: 0.25), value: message.isPartial)
            if !message.isFromUser {
                Spacer()
            }
        }
    }
    
    var messagingSection: some View {
        HStack {
            TextField(text: $userInput, prompt: Text("Type a message")) {
                EmptyView()
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(.trailing)
            .onSubmit {
                send()
            }
            
            Button {
                send()
            } label: {
                Text("Send")
            }
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Capsule().fill(ChaosClinicTheme.aiPurpleAccent))
            .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isAIResponding)
        }
        .padding(.top)
        .padding(.horizontal)
        .overlay(
            Rectangle()
                .fill(.black.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: 1, alignment: .top),
            alignment: .top
        )
        .background(.background)
    }
    
    private func send() {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        Task {
            await viewModel.sendMessage(trimmed)
            userInput = ""
        }
    }
}

@available(iOS 26.0, *)
extension ChatWithAiView {
    static func entryView(selection: Binding<AppTabState>, _emotion: Emotion) -> some View {
        ChatWithAiViewContainer(selection: selection, emotion: _emotion)
    }
}

#else

// Fallback implementation when FoundationModels is not available
struct ChatWithAiView: View {
    @Binding var selection: AppTabState
    @State private var messages: [Message] = [
        Message(id: UUID(), content: "Hello! How can I help you today?", isFromUser: false, isPartial: false)
    ]
    @State private var userInput: String = ""
    @State private var isAIResponding: Bool = false
    
    struct Message: Identifiable {
        let id: UUID
        let content: String
        let isFromUser: Bool
        let isPartial: Bool
    }
    
    var body: some View {
        VStack {
            appBar
                .padding()
                .background(
                    Rectangle()
                        .fill(ChaosClinicTheme.getColor(red: 102, green: 36, blue: 160, alpha: 1))
                        .shadow(color: .black.opacity(0.07), radius: 5, y: 8)
                )
            Spacer()
            
            conversationSection
                .padding(.bottom)
                .padding(.horizontal)
            
            messagingSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(stops: [
                .init(color: ChaosClinicTheme.getColor(red: 102, green: 36, blue: 160, alpha: 1), location: 0.1207),
                .init(color: .white, location: 0.6)
            ], startPoint: .init(x: 0.75, y: 0.2), endPoint: .init(x: 0.25, y: 1))
        )
    }
    
    var appBar: some View {
        HStack {
            Image(systemName: "arrow.left")
                .padding()
                .onTapGesture {
                    selection = .Dashboard
                }
            Spacer()
            ChaosClinicLogo(colorScheme: .dark, maxHeight: 54)
                .overlay(
                    Text("A.I.")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white.opacity(0.3))
                        )
                        .offset(x: 12, y: 2)
                        .scaleEffect(0.7),
                    alignment: .bottomTrailing
                )
        }
        .foregroundStyle(.white)
    }
    
    var conversationSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        messageView(message)
                            .id(message.id)
                            .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                    }
                    if isAIResponding {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: ChaosClinicTheme.aiPurpleAccent))
                            Text("Kanha is typing...")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(
                            Capsule()
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                .background(Capsule().fill(Color.white))
                        )
                        .id("loadingIndicator")
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: messages.count) { _ in
                if let lastId = messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                } else if isAIResponding {
                    withAnimation {
                        proxy.scrollTo("loadingIndicator", anchor: .bottom)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func messageView(_ message: Message) -> some View {
        HStack {
            if message.isFromUser {
                Spacer()
            }
            Text(message.content)
                .font(.callout)
                .foregroundColor(message.isFromUser ? .white : .black)
                .padding(.vertical, 12)
                .padding(.horizontal, message.isFromUser ? 28 : 24)
                .background(
                    Group {
                        if message.isFromUser {
                            Capsule()
                                .fill(ChaosClinicTheme.getColor(red: 188, green: 159, blue: 214, alpha: 1))
                        } else {
                            Capsule()
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                .background(Capsule().fill(Color.white))
                        }
                    }
                )
                .opacity(message.isPartial ? 0.5 : 1.0)
                .frame(maxWidth: .infinity, alignment: message.isFromUser ? .trailing : .leading)
                .animation(.easeInOut(duration: 0.25), value: message.isPartial)
            if !message.isFromUser {
                Spacer()
            }
        }
    }
    
    var messagingSection: some View {
        HStack {
            TextField(text: $userInput, prompt: Text("Type a message")) {
                EmptyView()
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(.trailing)
            .onSubmit {
                send()
            }
            
            Button {
                send()
            } label: {
                Text("Send")
            }
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Capsule().fill(ChaosClinicTheme.aiPurpleAccent))
            .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isAIResponding)
        }
        .padding(.top)
        .padding(.horizontal)
        .overlay(
            Rectangle()
                .fill(.black.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: 1, alignment: .top),
            alignment: .top
        )
        .background(.background)
    }
    
    private func send() {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let userMessage = Message(id: UUID(), content: trimmed, isFromUser: true, isPartial: false)
        messages.append(userMessage)
        userInput = ""
        isAIResponding = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let responseText = generateResponse(for: trimmed)
            let aiMessage = Message(id: UUID(), content: responseText, isFromUser: false, isPartial: false)
            withAnimation {
                messages.append(aiMessage)
                isAIResponding = false
            }
        }
    }
    
    private func generateResponse(for input: String) -> String {
        // Simple canned responses for fallback
        let lowercased = input.lowercased()
        if lowercased.contains("hello") || lowercased.contains("hi") {
            return "Hello! How can I assist you today?"
        } else if lowercased.contains("help") {
            return "I'm here to help! What do you need assistance with?"
        } else if lowercased.contains("thank") {
            return "You're welcome! If you have more questions, just ask."
        } else {
            return "I'm not sure how to respond to that, but I'm learning more every day!"
        }
    }
}

#endif
