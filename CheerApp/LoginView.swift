//
//  LoginView.swift
//  pia12nov20Firebase
//
//  Created by Lisa Gillfrost on 2024-03-14.
//

import SwiftUI
import Firebase

struct LoginView: View {
 
 @State var isRegistering = false
 @State var isLoggingIn = false
 
 var body: some View {
  VStack {

    if isLoggingIn  {
     Login(isLoggingIn: $isLoggingIn)
     
    } else if isRegistering{
     SignUp(isRegistering: $isRegistering)
     
    }
    else {
     FirstPageButtonView(isRegistering: $isRegistering, isLoggingIn: $isLoggingIn)
 
   }

  }.frame(maxWidth: .infinity).frame( maxHeight: .infinity).background(concrete)
 }
}

#Preview {
 LoginView()
}

struct FirstPageButtonView: View {
 
 @Binding var isRegistering: Bool
 @Binding var isLoggingIn: Bool
 
 var body: some View {
  
  VStack {
   
   VStack {
    Spacer()
   
    Image(uiImage: UIImage(named: "AppIcon")!)
     .resizable()
     .aspectRatio(contentMode: .fit)
     .frame(width: 150.0, height: 150.0)
     .cornerRadius(5.0)
    
    Spacer()
   }
   
   VStack {
    
    HStack {
     
     Button(action: {
      if isLoggingIn == false {
       isLoggingIn = true
      }
     }, label: {
      Text("Sign in")
     }).modifier(ButtonStyle())
     
     Button(action: {
      if isRegistering == false {
       isRegistering = true
       isLoggingIn = false
      }
     }, label: {
      Text("Sign up")
     }).modifier(ButtonStyle())
    }

    Spacer()
   }

  }
 }
}

struct ResetPassword: View {
 
 @State var email = ""
 @State var isButtonClicked = false
 @Binding var isResettingPassword: Bool
 @ObservedObject var userAuth = UserAuthentication()
 
 var body: some View {
  
  VStack {
   BackButton(Boolean: $isResettingPassword)
   
   Spacer()
   
   VStack {
    
    VStack {
     Text("Email:").modifier(TextFieldLabelStyle())
      TextField("Email", text: $email )
       .modifier(TextFieldStyle())
    }
    
    if isButtonClicked {
     
     Text("You will recieve an email with instructions on how to reset your password.")
      .frame(maxWidth: 250)
      .frame(width: 180)
      .foregroundStyle(.white)
      .padding()
    }
    
    Button(action: {
     userAuth.resetUserPassword(email: email)
     isButtonClicked = true
    }, label: {
     Text("Send")
     
    }).modifier(ButtonStyle())
    
   }
   Spacer()
   
  }
 }
}

struct BackButton: View {
 
 @Binding var Boolean: Bool
 
 var body: some View {
  HStack {
   
   Button(action: {
    Boolean = false
   }, label: {
    
    Image(systemName: "chevron.left")
     .foregroundColor(pink)
    
    Text("Back")
   }).modifier(ButtonStyle())
   
   Spacer()
  }
 }
}

struct SignUp: View {
 
 @State var email = ""
 @State var password = ""
 @State var passwordCopy = ""
 @State var isMatching = true
 @Binding var isRegistering: Bool
 @ObservedObject var userAuth = UserAuthentication()
 
 var body: some View {
  
  VStack {
   BackButton(Boolean: $isRegistering)
   
   Spacer()
   
   VStack {
    
    Text(isMatching == false ? "Passwords doesn't match" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
    
    VStack {
     Text("Email:").modifier(TextFieldLabelStyle())
     TextField("Email", text: $email )
      .modifier(TextFieldStyle())
    }.padding()
   
    VStack {
     Text("Password:").modifier(TextFieldLabelStyle())
     SecureField("Password", text: $password )
      .modifier(TextFieldStyle())
    }.padding()
   
    VStack {
     Text("Password again:").modifier(TextFieldLabelStyle())
     SecureField("Password again", text: $passwordCopy )
      .modifier(TextFieldStyle())
    }.padding()
    
    Button(action: {
     if password == passwordCopy {
      isMatching = true
      isRegistering = false
      userAuth.register(email: email, password: password)
     }else {
      isMatching = false
     }
    }, label: {
     Text("Submit")
    }).modifier(ButtonStyle())
   }
   Spacer()
  }
 }
}

struct Login: View {
 
 @State var email = ""
 @State var password = ""
 @Binding var isLoggingIn: Bool
 @State private var isResettingPassword = false
 @ObservedObject var userAuth = UserAuthentication()
 
 var body: some View {
  
  VStack {
   BackButton(Boolean: $isLoggingIn)
   
   Spacer()
   
   Text(userAuth.isIncorrect ? "Email or Password is incorrect" : "").foregroundColor(Color(red:1, green:0.57684861730000003, blue:0.64454441770000004))
   
   VStack {
    Text("Email:").modifier(TextFieldLabelStyle())
    TextField("Email", text: $email )
     .modifier(TextFieldStyle())
   }.padding()
  
   VStack {
    Text("Password:").modifier(TextFieldLabelStyle())
    SecureField("Password", text: $password )
     .modifier(TextFieldStyle())
   }.padding()
   
   Button(action: {
    userAuth.login(email: email, password: password)
   }, label: {
    Text("Sign in")
   }).modifier(ButtonStyle())
   
   Button(action: {
    isResettingPassword = true
   }, label: {
    Text("Reset password")
   }).modifier(ButtonStyle())
   
   
   Spacer()
   
  }
 }
}
