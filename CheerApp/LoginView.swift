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
 @State var isLoggingIn = false
 @State var text = ""
 @State var isResettingPassword = false
 
 @ObservedObject var userAuth = UserAuthentication()
 
 
 var body: some View {
  VStack {
   Text(userAuth.isIncorrect ? "Email or Password is incorrect" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
   
   Text(isMatching == false ? "Passwords doesn't match" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
   
   if isLoggingIn == true  {
    
    TextField("Email", text: $email ).background(.white).padding()
    
    TextField("Password", text: $password ).background(.white).padding()
    
   }
   
   if isRegistrering == true  {
    
    TextField("Email", text: $email ).background(.white).padding()
    
    TextField("Password", text: $password ).background(.white).padding()
    
    TextField("Password again", text: $passwordCopy ).textCase(.lowercase).background(.white).padding()
   }
   
   if isRegistrering == true {
    
    HStack {
     Button(action: {
      isRegistrering = false
     }, label: {
      Text("Close")
     }).modifier(ButtonStyle())
     
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
     }).modifier(ButtonStyle())
    }
   } else if isResettingPassword {
    Text("You will recieve an email with instructions on how to reset your password.").foregroundStyle(.white)
    
    TextField("Email", text: $email ).background(.white).padding()
    
    Button(action: {
      userAuth.resetUserPassword(email: email)
    }, label: {
     Text("Send")
     
    }).modifier(ButtonStyle())
    
    Button(action: {
      isResettingPassword = false
    }, label: {
     Text("Go back")
     
    }).modifier(ButtonStyle())
    
   }
   else {
    HStack {
     Button(action: {
      if isLoggingIn == false {
       isLoggingIn = true
      }
      else {
       userAuth.login(email: email, password: password)
      }
     }, label: {
      Text("Sign in")
     }).modifier(ButtonStyle())
     
     
     Button(action: {
      if isRegistrering == false {
       isRegistrering = true
       isLoggingIn = false
      }
     }, label: {
      Text("Sign up")
      
     }).modifier(ButtonStyle())
     
    }
    Button(action: {
      isResettingPassword = true
    }, label: {
     Text("Reset password")
     
    }).modifier(ButtonStyle())
    
   }
  }.frame(maxWidth: .infinity).frame( maxHeight: .infinity).background(concrete)
 }
 
}

#Preview {
 LoginView()
}
