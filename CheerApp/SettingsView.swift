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
    
    let user = Auth.auth().currentUser
    
    
    var body: some View {
        
        VStack {
            List {
                
                if let user = user {
                    Text("User: " + user.email!).padding().foregroundColor(.white).modifier(ListItemAction())
                }
         
                Button(action: {
                    UserAuthentication().logout()
                }, label: {
                    Text("Logga ut").foregroundColor(pink)
                })   .modifier(ListItemAction())
          
                Button( action: {
                    UserAuthentication().deleteUserAndAccount()
                }, label: {
                    Text("Radera konto").foregroundColor(pink)
                })   .modifier(ListItemAction())
    
                Button( action: {
                    showModal = false
                }, label: {
                    Text("Stäng").foregroundColor(pink)
                }).modifier(ListItemAction())
            }
            .listStyle(.plain)
        
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(concrete).tint(pink)
        
    }
}

