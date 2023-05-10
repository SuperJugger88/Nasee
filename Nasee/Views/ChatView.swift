//
//  ChatView.swift
//  Nasee
//
//  Created by Андрей Иванов on 17/04/2023.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var gpt3ViewModel = ChatViewModel()
    @State var typingMessage: String = ""
    @Namespace var bottomID
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                if !gpt3ViewModel.messages.isEmpty{
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(gpt3ViewModel.messages) { message in
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        
                        .onChange(of: gpt3ViewModel.messages.last?.content as? String) { _ in
                            DispatchQueue.main.async {
                                withAnimation {
                                    reader.scrollTo(bottomID)
                                }
                            }
                        }
                        .onChange(of: gpt3ViewModel.messages.count) { _ in
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                        
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack{
                        Image(systemName: "ellipses.bubble")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Write your first message!")
                            .font(.subheadline)
                            .padding(10)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack(alignment: .center){
                    TextField("", text: $typingMessage, prompt: Text("Message...").foregroundColor(.gray), axis: .vertical)
                        .foregroundColor(.white)
                        .focused($fieldIsFocused)
                        .padding()
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                    Button(action: sendMessage) {
                        Image(systemName: typingMessage.isEmpty ? "circle" : "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
                .cornerRadius(12)
                .padding([.leading, .trailing, .bottom], 10)
                .shadow(color: .black, radius: 0.5)
            }
            .background(Color(red: 53/255, green: 54/255, blue: 65/255))
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
            .navigationTitle("Nasee")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        hideKeyboard()
        Task{
            await gpt3ViewModel.getResponse(text: tempMessage)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

struct ChatView_Previews : PreviewProvider {
    
    static var previews: some View {
        Group {
            ChatView()
        }
    }
    
}
