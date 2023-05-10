//
//  AuthorizationButtonsView.swift
//  Nasee
//
//  Created by Андрей Иванов on 30.04.2023.
//

import SwiftUI


struct AuthorizationButtonsView : View {
    
    @State private var isShowing = false
    
    let buttons : [(AnyView, String, Color)] = [
        (AnyView(LoginView()),"Log In", Color.blue),
        (AnyView(SignUpView()),"Sign Up", Color.gray)
    ]
    
    var body: some View {
        ForEach(0..<buttons.count) { index in
            NavigationLink(destination: buttons[index].0) {
                Text(buttons[index].1)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(buttons[index].2)
                    .cornerRadius(10.0)
                    .fontDesign(.monospaced)
                    .opacity(isShowing ? 1.0 : 0.0)
                    .onAppear {
                        withAnimation {
                            isShowing = true
                        }
                    }
            }
        }
    }
}
