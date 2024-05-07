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
    
    var body: some View {
        
        VStack {
            
            if isLoggedIn {
                ContentView()
            }else {
                LoginView()
            }
        }
        .onAppear(){
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
        .background(concrete)
    }
}

#Preview {
    StartView()
}
