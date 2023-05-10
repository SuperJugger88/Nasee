//
//  ContentView.swift
//  iBooker
//
//  Created by Андрей Иванов on 12/04/2023.
//

import SwiftUI
import Firebase


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPasswordCorrect = false
    @AppStorage("isOn") var isRememberMeOn = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Log in to your account")
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
                }
                .padding(.horizontal, 20)
                
                Toggle(isOn: $isRememberMeOn) {
                    Text("Remember me")
                        .foregroundColor(.white)
                        .fontDesign(.monospaced)
                        .font(.headline)
                }
                .padding(.top, 10)
                .frame(width: 340)

                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let registerFail = error {
                            showAlert = true
                            alertMessage = registerFail.localizedDescription
                        } else {
                            isPasswordCorrect = true
                        }
                    }
                }) {
                    Text("Log In")
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

                Text("Forgot password?")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .fontDesign(.monospaced)
                
                NavigationLink(
                    destination: ChatView(),
                    isActive: $isPasswordCorrect,
                    label: {EmptyView()}
                ).hidden()
                
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                        .fontDesign(.monospaced)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(.systemTeal), Color(.systemGreen)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onDisappear() {
                let defaults = UserDefaults.standard

                defaults.set(email, forKey: "email")
                defaults.set(password, forKey: "password")
            }
            .onAppear() {
                if isRememberMeOn {
                    let defaults = UserDefaults.standard
                    if let savedUsername = defaults.string(forKey: "email") {
                        email = savedUsername
                    }
                    if let savedPassword = defaults.string(forKey: "password") {
                        password = savedPassword
                    }
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                        isPasswordCorrect = true
                    }
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
