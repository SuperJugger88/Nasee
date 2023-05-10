//
//  ContentView.swift
//  iBooker
//
//  Created by Андрей Иванов on 12/04/2023.
//

import SwiftUI


struct WelcomeView: View {
    
    @State private var dayTime = DayTime()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        ForEach(0..<2) { order in
                            Image("icon\(order+1)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .padding(.horizontal)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 2)
                                }
                                .animation(.interpolatingSpring(stiffness: 50.0, damping: 5.0))
                        }
                    }
                    
                    Text("Good \(dayTime.getDayTime())")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .red, radius: 10)
                        .fontDesign(.rounded)
                        .padding()
                    
                    AuthorizationButtonsView()

                }
                .background(Image("clover-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 1450)
                    .blur(radius: 6)
                )
            }
        }
    }    
}

struct ContentView_Previews : PreviewProvider {
    
    static var previews : some View {
        Group {
            WelcomeView()
        }
    }
}

