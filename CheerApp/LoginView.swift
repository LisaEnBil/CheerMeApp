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
    @State var passwordCopy = ""
    @State var isMatching = true
    @State var isRegistrering = false
    @State var text = ""
    
    @ObservedObject var userAuth = UserAuthentication()
    
    
    var body: some View {
        VStack {
            
            
            Text(userAuth.isIncorrect ? "Email or Password is incorrect" : "")
            
            Text(isMatching == false ? "Passwords doesn't match" : "")
            
            TextField("Email", text: $email )
            
            TextField("Password", text: $password ).textCase(.lowercase)
            
            if isRegistrering == true  {
                TextField("Password again", text: $passwordCopy ).textCase(.lowercase)
            }
            if isRegistrering == true {
                Button(action: {
                    if password == passwordCopy {
                        isMatching = true
                        isRegistrering = false
                        userAuth.register(email: email, password: password)
                    }else {
                        isMatching = false
                    }
                    
                }, label: {
                    Text("Submit")
                    
                })
            } else {
                
                Button(action: {
                    userAuth.login(email: email, password: password)
                }, label: {
                    Text("Login")
                })
                
                Button(action: {
                    if isRegistrering == false {
                        isRegistrering = true
                    }
                }, label: {
                    Text("Register")
                    
                })
            }
          
           
            
            
        }
    }
    
}

#Preview {
    LoginView()
}

