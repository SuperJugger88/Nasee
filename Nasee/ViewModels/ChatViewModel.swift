//
//  ChatViewModel.swift
//  Nasee
//
//  Created by Андрей Иванов on 17/04/2023.
//

import Foundation
import ChatGPTSwift

class ChatViewModel: ObservableObject {
    
    let api : ChatGPTAPI
    @Published var messages = [Message]()
    
    init() {
        guard let configPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: configPath) as? [String: Any],
              let apiKey = configDict["API_KEY"] as? String else {
                fatalError("Не удалось загрузить API ключ из Config.plist")
        }
        self.api = ChatGPTAPI(apiKey: apiKey)
    }
    
    func getResponse(text: String) async{
        
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage("", type: .text, isUserMessage: false)

        do {
            let stream = try await api.sendMessageStream(text: text)

            for try await line in stream {
                DispatchQueue.main.async {
                    
                    self.messages[self.messages.count - 1].content = self.messages[self.messages.count - 1].content as! String + line
                }
            }
        } catch {
            self.addMessage(error.localizedDescription, type: .error, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty just addl new message
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, type: type, isUserMessage: isUserMessage)
                self.messages.append(message)
                return
            }
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            // if last message is an indicator switch with new one
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
            } else {
                // otherwise, add new message to the end of the list
                self.messages.append(message)
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
    
}
