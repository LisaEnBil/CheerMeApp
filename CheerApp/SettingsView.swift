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
                    Text("Sign out").foregroundColor(pink)
                })   .modifier(ListItemAction())
                
                
                Button("Delete account") {
                          self.isShowingPopover = true
                      }
                      .popover(isPresented: $isShowingPopover) {
                          
                          VStack {
                              Text("Are you sure you want to delete your account?")
                                  .foregroundColor(.white)
                                  .font(.title2)
                                  .padding()
                              
                              HStack {
                                  
                                  Spacer()
                                  
                                  Button( action: {
                                      self.isShowingPopover = false
                                  }, label: {
                                      Text("No").foregroundColor(pink).font(.title2)
                                  })   .modifier(ListItemAction())
                                      .padding()
                                  
                                  Spacer()
                                  
                                  Button( action: {
                                      UserAuthentication().deleteUserAndAccount()
                                  }, label: {
                                      Text("Yes").foregroundColor(pink).font(.title2)
                                  })   .modifier(ListItemAction())
                                  
                                  Spacer()
                                  
                              }
                              Spacer()
                          }.frame(maxWidth: .infinity, maxHeight: .infinity).background(concrete)
                       
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

