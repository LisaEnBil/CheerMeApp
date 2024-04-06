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
   Text(userAuth.isIncorrect ? "Email or Password is incorrect" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
   
   Text(isMatching == false ? "Passwords doesn't match" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
   
   TextField("Email", text: $email ).background(.white).padding()
   
   TextField("Password", text: $password ).background(.white).padding()
   
   if isRegistrering == true  {
    TextField("Password again", text: $passwordCopy ).textCase(.lowercase).background(.white).padding()
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
    }).padding()
    
    Button(action: {
     isRegistrering = false
    }, label: {
     Text("Close")
    }).padding()
    
   } else {
    Button(action: {
     userAuth.login(email: email, password: password)
    }, label: {
     Text("Login")
    }).padding()
    
    Button(action: {
     if isRegistrering == false {
      isRegistrering = true
     }
    }, label: {
     Text("Register")
     
    }).padding()
   }
  }.frame(maxHeight: .infinity).background(Color(white: 0.258))
 }
 
}

#Preview {
 LoginView()
}


//Color(red:1, green:0.57684861730000003, blue:0.64454441770000004)
