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
    var body: some View {
        
        VStack {
            Button(action: {
                UserAuthentication().logout()
            }, label: {
                Text("Logga ut")
            })
            
            Button( action: {
                UserAuthentication().deleteUserAndAccount()
            }, label: {
                Text("Radera konto")
            })
            Button( action: {
                showModal = false
            }, label: {
                Text("Stäng")
            })
        }
    }
}

