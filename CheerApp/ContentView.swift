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



struct CatListRow<Destination: View>: View {
    let cat: CatModel
    let destination: () -> Destination
    let onDelete: () async -> Void

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(alignment: .top, spacing: 20) {
                Image(uiImage: cat.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    
                    
                    
                 
                
                VStack(alignment: .leading) {
                        
                    Text(cat.name)
                        .bold()
                }
                Spacer()
            }
            .padding()
            .foregroundStyle(pink)
            .background(concrete)
        }
        .listRowBackground(Color.gray)
        .listRowSeparatorTint(pink)
    }
}

struct ContentView: View {
    
    @State private var showAddCatModal = false
    @State private var showSettingsModal = false
    @State var image: UIImage?

    @ObservedObject var catHelpers = CatHelpers()
    @ObservedObject var audioRecorder = AudioManager()
    
    var body: some View {
        
        NavigationStack {
            List(catHelpers.cats, id: \.self) { cat in
                CatListRow(cat: cat, destination: {
                    CatView(model: cat)
                }) {
                    await catHelpers.deleteCat(id: cat.id)
                }   .swipeActions(edge: .trailing) {
                    if !catHelpers.libraryCats.contains(cat) {
                            Button(role: .destructive, action: {
                                Task {
                                    await catHelpers.deleteCat(id: cat.id)
                                }
                            }, label: {
                                Label("Delete", systemImage: "trash")
                            })
                        }
                        
                        
                    }
            }
            .background(.gray)
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarContent)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(concrete)
        }
        .onAppear(){
            catHelpers.loadStoredCats(dbRef: "library_cats" )
            catHelpers.loadStoredCats(dbRef: "user_cat_list" )
            audioRecorder.deleteRecording()
          
        }
        .tint(pink)
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent{
        
        ToolbarItem(placement: .topBarLeading) {
            Button("Add cat") {
                showAddCatModal = true
            }
            .sheet(isPresented: $showAddCatModal) {
                AddCatView(showModal: $showAddCatModal, image: $image, name: "", id: "", cats: $catHelpers.cats)
            }
        }
        ToolbarItem(placement: .principal) {
            Text("Home")
                .foregroundStyle(.white)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                showSettingsModal = true
            }){
                Image(systemName: "gearshape")
            }
            .sheet(isPresented: $showSettingsModal) {
                SettingsView(showModal: $showSettingsModal)
            }
        }
    }
}

#Preview {
    ContentView()
}
