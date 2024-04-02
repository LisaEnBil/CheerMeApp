//
//  LoginView.swift
//  pia12nov20Firebase
//
//  Created by Lisa Gillfrost on 2024-03-14.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email )
            
            TextField("Password", text: $password )
            
            Button(action: {
                login()
            }, label: {
            Text("Login")
            })
            
            Button(action: {
                register()
            }, label: {
            Text("Register")
   
            })
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
           
            if error == nil {
                print("Login OK")
            } else {
                print("Login fail")
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
             if error == nil {
                 print("Register OK")
             } else {
                 print("Register fail")
             }
        }
    }
}

#Preview {
    LoginView()
}

