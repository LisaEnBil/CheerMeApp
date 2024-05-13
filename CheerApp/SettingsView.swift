//
//  SettingsView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-04-05.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct SettingsView: View {
    @Binding var showModal: Bool
    @State private var isShowingPopover = false
    @State private var isDeletingAccount = false
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack {
            if isDeletingAccount == true {
                DeleteAccountProgressView(Boolean: $isDeletingAccount)
            }
            VStack {
                List {
                    
                    if let user = user {
                        Text("User: " + user.email!).padding().foregroundColor(.white).modifier(ListItemAction())
                    }
                    
                    Button(action: {
                        UserAuthentication().logout()
                    }, label: {
                        Text("Sign out").foregroundColor(pink)
                    })   .modifier(ListItemAction())
                    
                    
                    Button("Delete account") {
                        self.isShowingPopover = true
                    }
                    .popover(isPresented: $isShowingPopover) {
                        
                        DeleteAcountView(isShowingPopover: $isShowingPopover, isDeletingAccount: $isDeletingAccount)
                        
                    }.modifier(ListItemAction()).foregroundColor(pink)
                    
                    Button( action: {
                        showModal = false
                    }, label: {
                        Text("Close").foregroundColor(pink)
                    }).modifier(ListItemAction())
                    
                }
                .listStyle(.plain)
                
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(concrete).tint(pink)
            
        }
        
    }
}

struct DeleteAccountProgressView: View {
    
    @Binding var Boolean: Bool
    
    var body: some View {
        VStack {
            ProgressView()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}


struct DeleteAcountView: View {
    @Binding var isShowingPopover: Bool
    @Binding var isDeletingAccount: Bool
    @State var isReauthenticated = false
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        VStack {
            Text("Are you sure you want to delete your account?")
                .foregroundColor(.white)
                .font(.title2)
                .padding()
            
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
                reAuthenticateUser(email: email, password: password)
                email = ""
                password = ""
                
            }, label: {
                Text("Delete acount")
            }).modifier(ButtonStyle())
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(concrete)
        
    }
    
    func reAuthenticateUser(email: String, password: String) {
        
        let userEmail = Auth.auth().currentUser?.email
        
        if userEmail == email {
            do {
                UserAuthentication().login(email: email, password: password)
                isReauthenticated = true
                
                print("Reauthentication succeeded")
            } catch let error {
                print("Couldn't reauthenticate: \(error.localizedDescription)")
                
            }
            
            if isReauthenticated {
                
                UserAuthentication().deleteUserAndAccount()
            }
        } else {
            
            print("Couldn't reauthenticate, emails doesn't match")
        }
    }
}

