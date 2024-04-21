//
//  ContentView.swift
//  CheerApp
//
//  Created by Lisa Gillfrost on 2024-03-01.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct ContentView: View {
    
    @State private var showAddCatModal = false
    @State private var showSettingsModal = false
    @State var image: UIImage?
   
    
    @ObservedObject var catHelpers = CatHelpers()
    @ObservedObject var audioRecorder = AudioManager()
  
    
    var image1: UIImage?
    
    var body: some View {
        NavigationStack {
            
            Button("Add cat") {
                showAddCatModal = true
            } .sheet(isPresented: $showAddCatModal) {
                AddCatView(showModal: $showAddCatModal, image: $image, name: "", id: "", cats: $catHelpers.cats)
            }
            
            List(catHelpers.cats, id: \.self) { cat in
                NavigationLink {
                    CatView(model: cat)
                    
                    
                } label: {
                    
                    VStack(alignment: .center) {
                        Image(uiImage: cat.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200).swipeActions(edge: .trailing) {
                                Button(action: {
                                    Task {
                                        await catHelpers.deleteCat()
                                    }
                                   
                                },
                                 label: {
                                    Label("Delete", systemImage: "trash")
                                })
                              
                            }
                        Text(cat.name)
                        
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                Button(action: {
                    showSettingsModal = true
                }, label: {
                    Image(systemName: "gearshape")
                }).sheet(isPresented: $showSettingsModal) {
                    SettingsView(showModal: $showSettingsModal)
                }
                
            }
        }.onAppear(){
            catHelpers.loadStoredCats(dbRef: "library_cats" )
            catHelpers.loadStoredCats(dbRef: "user_cat_list" )
            audioRecorder.deleteRecording()
        }
    }
}

//#Preview {
//    ContentView()
//}
