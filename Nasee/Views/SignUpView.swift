//
//  SignUpView.swift
//  iBooker
//
//  Created by Андрей Иванов on 13/04/2023.
//

import SwiftUI
import Firebase


struct SignUpView : View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPasswordCorrect = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Create your account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontDesign(.monospaced)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)

                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .fontDesign(.monospaced)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .fontDesign(.monospaced)
                    
                    SecureField("Confirm password", text: $confirm)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .fontDesign(.monospaced)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    if confirm != password {
                        showAlert = true
                        alertMessage = "Passwords don't match. Try again"
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let registerFail = error {
                                showAlert = true
                                alertMessage = registerFail.localizedDescription
                            } else {
                                isPasswordCorrect = true
                            }
                        }
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8.0)
                        .padding(.top, 20)
                        .fontDesign(.monospaced)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                NavigationLink(
                    destination: ChatView(),
                    isActive: $isPasswordCorrect,
                    label: {EmptyView()}
                ).hidden()

                NavigationLink(destination: LoginView()) {
                    Text("Already have an account?")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                        .fontDesign(.monospaced)
                }
                
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(.purple), Color(.orange)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    .navigationBarTitle("")
    .navigationBarHidden(true)
    }
}
