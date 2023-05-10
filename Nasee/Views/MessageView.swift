//
//  MessageView.swift
//  Nasee
//
//  Created by Андрей Иванов on 17/04/2023.
//

import SwiftUI

struct MessageView: View {
    var message: Message

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: message.isUserMessage ? .center : .top){
                    Image(message.isUserMessage ? "icon2" : "icon1")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)

                    switch message.type {
                    case .text:
                        let output = (message.content as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                        Text(output)
                            .foregroundColor(.white)
                            .textSelection(.enabled)
                    case .error:
                        let output = (message.content as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                        Text(output)
                            .foregroundColor(.red)
                            .textSelection(.enabled)
                    case .indicator:
                        MessageIndicatorView()
                    }
                }
                .padding([.top, .bottom])
                .padding(.leading, 10)
            }
            Spacer()
        }
        .background(message.isUserMessage ? Color(red: 53/255, green: 54/255, blue: 65/255) : Color(red: 68/255, green: 70/255, blue: 83/255))
        .shadow( radius: message.isUserMessage ? 0 : 0.5)

    }
}
