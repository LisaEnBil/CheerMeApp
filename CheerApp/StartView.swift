//
//  StartView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-01.
//

import SwiftUI
import Firebase

struct StartView: View {
    
    @State var isLoggedIn = false
    @State var showSplash: Bool = false
    
    var body: some View {
        
        ZStack {
            if self.showSplash {
                VStack {
                    
                    if isLoggedIn {
                        ContentView()
                    }else {
                        LoginView()
                    }
                }
            } else {
                
                Color(red: 237/255, green: 119/255, blue: 123/255)
                    .ignoresSafeArea()
                Image(uiImage: UIImage(named: "AppIcon")!)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 150.0, height: 150.0)
                 .cornerRadius(5.0)
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.showSplash = true
                }
                
                Auth.auth().addStateDidChangeListener {
                    auth, user in
                                    
                    if Auth.auth().currentUser == nil {
                        isLoggedIn = false
                    }else {
                        isLoggedIn = true
                        print(Auth.auth().currentUser?.uid as Any)
                    }
                }
            }
        }
    }
}

#Preview {
    StartView()
}

