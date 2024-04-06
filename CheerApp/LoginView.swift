//
//  LoginView.swift
//  pia12nov20Firebase
//
//  Created by Lisa Gillfrost on 2024-03-14.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let userAuth = UserAuthentification()
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email )
            
            TextField("Password", text: $password ).textCase(.lowercase)
            
            Button(action: {
                userAuth.login(email: email, password: password)
            }, label: {
            Text("Login")
            })
            
            Button(action: {
                userAuth.register(email: email, password: password)
            }, label: {
            Text("Register")
   
            })
        }
    }
  
}

#Preview {
    LoginView()
}

