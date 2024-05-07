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
 @State private var isResettingPassword = false
 
 var body: some View {
  VStack {
   
   if isLoggingIn  {
    Login(isLoggingIn: $isLoggingIn)
    
   } else if isRegistering{
    SignUp(isRegistering: $isRegistering)
    
   } else if isResettingPassword{
    ResetPassword(isResettingPassword: $isResettingPassword)
   } else {
    FirstPageButtonView(isRegistering: $isRegistering, isLoggingIn: $isLoggingIn, isResettingPassword: $isResettingPassword)
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
 @Binding var isResettingPassword: Bool
 
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
    
    Button(action: {
     isResettingPassword = true
     
    }, label: {
     Text("Reset password")
    }).modifier(ButtonStyle())
    
    Spacer()
   }
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
 @State private var showError = false
 @State var passwordTooShort = false
 
 var body: some View {
  
  VStack {

    BackButton(Boolean: $isRegistering)
  

   Spacer()
   if passwordTooShort{
    Text("Password is too short, password needs to exist of at least 6 characters").foregroundColor(.red)
   }
  
   if !isMatching {
    Text("Passwords doesn't match").foregroundColor(.red)
   }
   
   if showError {
    Text("Registration failed, incorrect email format.")
     .foregroundColor(.red)
     .padding()
   }
   
   Text("Email:").modifier(TextFieldLabelStyle())
   TextField("Email", text: $email )
    .modifier(EmailFieldStyle())
    .modifier(TextFieldStyle())
    .padding([.bottom], 10)

   Text("Password:").modifier(TextFieldLabelStyle())
   SecureField("Password", text: $password )
    .disableAutocorrection(true)
    .modifier(TextFieldStyle())
    .padding([.bottom], 10)
   
   Text("Password again:").modifier(TextFieldLabelStyle())
   SecureField("Password again", text: $passwordCopy )
    .disableAutocorrection(true)
    .modifier(TextFieldStyle())
    .padding([.bottom], 10)
   
   Button(action: {
    
    if password.count >= 6 && password == passwordCopy {
     isMatching = true
 
     Task {
      do {
       try await userAuth.registerUser(email: email, password: password)
       isRegistering = false
       print("Registration and email verification successful")
      } catch {
       isRegistering = true
       showError = true
      }
     }
    } else if password.count < 6 {
     passwordTooShort = true
    }
    else {
     isMatching = false
    }
   }, label: {
    Text("Submit")
   }).modifier(ButtonStyle())
   
   Spacer()
  }
 }
}

struct Login: View {
 
 @State var email = ""
 @State var password = ""
 @Binding var isLoggingIn: Bool
 @ObservedObject var userAuth = UserAuthentication()
 
 var body: some View {
  
  VStack {
   BackButton(Boolean: $isLoggingIn)
   Spacer()
   Text(userAuth.isIncorrect ? "Email or Password is incorrect" : "").foregroundColor(.red)
   
   Text("Email:").modifier(TextFieldLabelStyle())
   TextField("Email", text: $email )
    .modifier(EmailFieldStyle())
    .modifier(TextFieldStyle())
    .padding([.bottom], 10)
   
   Text("Password:").modifier(TextFieldLabelStyle())
   SecureField("Password", text: $password )
    .disableAutocorrection(true)
    .modifier(TextFieldStyle())
    .padding([.bottom], 10)
   
   Button(action: {
    userAuth.login(email: email, password: password)
    
   }, label: {
    Text("Sign in")
   }).modifier(ButtonStyle())
   
   Spacer()
  }
 }
}

struct ResetPassword: View {
 
 @State var email = ""
 @State var isButtonClicked = false
 @Binding var isResettingPassword: Bool
 @ObservedObject var userAuth = UserAuthentication()
 @State private var showError = false
 
 var body: some View {
  
  VStack {
   BackButton(Boolean: $isResettingPassword)
   
   Spacer()
   
   VStack {
    
    if showError {
     Text("Incorrect email format.")
      .foregroundColor(.red)
      .padding()
    }
    
    Text("Email:").modifier(TextFieldLabelStyle())
    TextField("Email", text: $email )
     .modifier(EmailFieldStyle())
     .modifier(TextFieldStyle())
     .padding([.bottom], 10)
    
    if isButtonClicked {
     
     Text("You will recieve an email with instructions on how to reset your password.")
      .frame(maxWidth: 250)
      .frame(width: 180)
      .foregroundStyle(.white)
      .padding()
    }
    
    Button(action: {
     Task {
      do {
       try await userAuth.resetUserPassword(email: email)
       print("Password reset email sent successfully")
      } catch {
       showError = true
       print("Error resetting password: \(error.localizedDescription)")
      }
     }
     
    }, label: {
     Text("Send")
     
    }).modifier(ButtonStyle())
   }
   Spacer()
   
  }
 }
}
